// src/models/Product.js (UPDATED TO MATCH CONTROLLER)
const { DataTypes, Op } = require("sequelize");
const { sequelize } = require("../config/database");

const Product = sequelize.define(
  "Product",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    clientId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "client_id",
    },
    categoryId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "category_id",
    },
    supplierId: {
      type: DataTypes.UUID,
      allowNull: true,
      field: "supplier_id",
    },
    // ✅ NEW FIELDS (Required by Controller)
    productType: {
      type: DataTypes.STRING(20), // "Tunai", "Beli Putus", "Konsinyasi"
      defaultValue: "Tunai",
      field: "product_type",
    },
    purchaseType: {
      type: DataTypes.STRING(20), // "TUNAI", "KREDIT", "KONSINYASI"
      defaultValue: "TUNAI",
      field: "purchase_type",
    },
    invoiceNo: {
      type: DataTypes.STRING(50),
      allowNull: true,
      field: "invoice_no",
    },
    expiryDate: {
      type: DataTypes.DATE,
      allowNull: true,
      field: "expiry_date",
    },
    // End New Fields
    barcode: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },
    sku: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    unit: {
      type: DataTypes.STRING(20),
      defaultValue: "PCS",
    },
    purchasePrice: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "purchase_price",
    },
    // Harga Jual Utama (Umum)
    sellingPrice: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "selling_price",
    },
    // ✅ Tambahan Harga Jual Khusus (Sesuai Controller)
    sellingPriceGeneral: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "selling_price_general",
    },
    sellingPriceMember: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "selling_price_member",
    },
    stock: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
    },
    minStock: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      field: "min_stock",
    },
    maxStock: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      field: "max_stock",
    },
    points: {
      type: DataTypes.DECIMAL(10, 2),
      defaultValue: 0,
    },
    description: DataTypes.TEXT,
    image: DataTypes.STRING(255),
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
      field: "is_active",
    },
  },
  {
    tableName: "products",
    timestamps: true,
    underscored: true,
    indexes: [
      { unique: true, fields: ["client_id", "sku"] },
      { unique: true, fields: ["client_id", "barcode"] },
      { fields: ["client_id", "name"] },
    ],
  },
);

// --- INSTANCE METHODS ---

// ✅ Tambah Stok
Product.prototype.addStock = async function (quantity, transaction = null) {
  this.stock = parseInt(this.stock) + parseInt(quantity);
  await this.save({ transaction });
};

// ✅ Kurangi Stok (Ini yang tadi Error "not a function")
Product.prototype.reduceStock = async function (quantity, transaction = null) {
  const currentStock = parseInt(this.stock);
  const qtyToReduce = parseInt(quantity);

  if (currentStock < qtyToReduce) {
    throw new Error(
      `Stok tidak cukup. Tersedia: ${currentStock}, Diminta: ${qtyToReduce}`,
    );
  }

  this.stock = currentStock - qtyToReduce;
  await this.save({ transaction });
};

Product.prototype.isLowStock = function () {
  return this.stock <= this.minStock;
};
Product.prototype.isOutOfStock = function () {
  return this.stock === 0;
};

Product.prototype.toJSON = function () {
  const values = { ...this.get() };
  [
    "purchasePrice",
    "sellingPrice",
    "sellingPriceGeneral",
    "sellingPriceMember",
    "points",
  ].forEach((k) => {
    if (values[k]) values[k] = parseFloat(values[k]);
  });
  values.isLowStock = this.isLowStock();
  return values;
};

Product.generateSKU = async function (clientId) {
  const dateStr = new Date().toISOString().slice(0, 10).replace(/-/g, ""); // YYYYMMDD
  const lastProduct = await this.findOne({
    where: {
      clientId,
      sku: { [Op.like]: `PRD-${dateStr}-%` },
    },
    order: [["sku", "DESC"]],
  });

  let nextNumber = 1;
  if (lastProduct) {
    const parts = lastProduct.sku.split("-");
    nextNumber = (parseInt(parts[parts.length - 1]) || 0) + 1;
  }
  return `PRD-${dateStr}-${String(nextNumber).padStart(3, "0")}`;
};

module.exports = Product;
