// src/models/Sale.js (SAAS + POINTS SYSTEM READY)
const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Sale = sequelize.define(
  "Sale",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    // ✅ WAJIB ADA: Client ID
    clientId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "client_id",
    },
    memberId: {
      type: DataTypes.UUID,
      allowNull: true,
      field: "member_id",
    },
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "user_id",
    },
    invoiceNumber: {
      type: DataTypes.STRING(50),
      allowNull: false,
      field: "invoice_number",
    },
    saleDate: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
      field: "sale_date",
    },
    saleType: {
      type: DataTypes.ENUM("TUNAI", "KREDIT"),
      allowNull: false,
      defaultValue: "TUNAI",
      field: "sale_type",
    },
    totalAmount: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "total_amount",
    },
    discountAmount: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "discount_amount",
    },
    discountPercentage: {
      type: DataTypes.DECIMAL(5, 2),
      defaultValue: 0,
      field: "discount_percentage",
    },
    finalAmount: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "final_amount",
    },
    dpAmount: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "dp_amount",
    },
    remainingDebt: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "remaining_debt",
    },
    paymentReceived: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "payment_received",
    },
    changeAmount: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "change_amount",
    },
    dueDate: {
      type: DataTypes.DATE,
      allowNull: true,
      field: "due_date",
    },
    status: {
      type: DataTypes.ENUM("PENDING", "PARTIAL", "PAID", "CANCELLED"),
      defaultValue: "PAID",
    },
    notes: DataTypes.TEXT,
  },
  {
    tableName: "sales",
    timestamps: true,
    underscored: true,
    indexes: [
      // ✅ Invoice Unik Per Client
      { unique: true, fields: ["client_id", "invoice_number"] },
      { fields: ["client_id", "sale_date"] },
      { fields: ["member_id"] },
      { fields: ["user_id"] },
    ],
  },
);

// ✅ INSTANCE METHOD: Formatting Angka (Dibalikin lagi)
Sale.prototype.toJSON = function () {
  const values = { ...this.get() };
  [
    "totalAmount",
    "discountAmount",
    "finalAmount",
    "dpAmount",
    "remainingDebt",
    "paymentReceived",
    "changeAmount",
  ].forEach((field) => {
    if (values[field]) values[field] = parseFloat(values[field]);
  });
  if (values.discountPercentage)
    values.discountPercentage = parseFloat(values.discountPercentage);
  return values;
};

// ✅ STATIC METHOD: Generate Invoice
Sale.generateInvoice = async function (clientId) {
  const dateStr = new Date()
    .toISOString()
    .slice(0, 10)
    .replace(/-/g, "")
    .slice(2); // YYMMDD
  const { Op } = require("sequelize");

  const lastSale = await this.findOne({
    where: {
      clientId,
      invoiceNumber: { [Op.like]: `${dateStr}-%` },
    },
    order: [["invoiceNumber", "DESC"]],
  });

  let nextNum = 1;
  if (lastSale) {
    const parts = lastSale.invoiceNumber.split("-");
    nextNum = (parseInt(parts[1]) || 0) + 1;
  }
  return `${dateStr}-${String(nextNum).padStart(4, "0")}`;
};

// ✅ HOOK: Hitung Point Otomatis (Dibalikin lagi)
Sale.afterCreate(async (sale, options) => {
  try {
    if (!sale.memberId) return;

    // Cek Setting (Per Client)
    const Setting = require("./Setting");
    // Perlu logic khusus untuk ambil setting per client, sementara kita skip validasi setting dulu atau asumsi true
    // atau fetch setting manual:
    const pointEnabledSetting = await Setting.findOne({
      where: { clientId: sale.clientId, key: "point_enabled" },
    });

    // Kalau setting gak ketemu atau false, skip
    if (!pointEnabledSetting || pointEnabledSetting.value !== "true") return;

    const PointTransaction = require("./PointTransaction");
    const SaleItem = require("./SaleItem");
    const { calculateTransactionPoints } = require("../utils/pointCalculator");

    const saleItems = await SaleItem.findAll({
      where: { saleId: sale.id },
      transaction: options.transaction,
    });

    if (saleItems.length === 0) return;

    const items = saleItems.map((item) => ({
      productId: item.productId,
      productName: item.productName,
      quantity: item.quantity,
      subtotal: parseFloat(item.subtotal),
      sellingPrice: parseFloat(item.sellingPrice),
    }));

    const pointResult = await calculateTransactionPoints(items);

    if (pointResult.totalPoints > 0) {
      await PointTransaction.recordEarn(
        sale.memberId,
        sale.id,
        pointResult.totalPoints,
        `Point Transaksi #${sale.invoiceNumber}`,
        options.transaction,
      );
      console.log(
        `✅ ${pointResult.totalPoints} Points added to Member ${sale.memberId}`,
      );
    }
  } catch (error) {
    console.error(
      `❌ Point Error (Sale ${sale.invoiceNumber}):`,
      error.message,
    );
  }
});

module.exports = Sale;
