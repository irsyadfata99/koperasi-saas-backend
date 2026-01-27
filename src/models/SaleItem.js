// src/models/SaleItem.js (SAAS + FORMATTING READY)
const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const SaleItem = sequelize.define(
  "SaleItem",
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
    saleId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "sale_id",
    },
    productId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "product_id",
    },
    productName: {
      type: DataTypes.STRING(100),
      allowNull: false,
      field: "product_name",
      comment: "Snapshot nama produk saat transaksi",
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: { min: 1 },
    },
    unit: {
      type: DataTypes.STRING(20),
      allowNull: false,
    },
    sellingPrice: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      field: "selling_price",
    },
    subtotal: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
    },
    pointsEarned: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      field: "points_earned",
    },
  },
  {
    tableName: "sale_items",
    timestamps: true,
    underscored: true,
  },
);

// ✅ INSTANCE METHOD: Formatting Angka (Dibalikin lagi)
// Biar di frontend gak perlu parseInt/parseFloat manual lagi
SaleItem.prototype.toJSON = function () {
  const values = { ...this.get() };

  if (values.sellingPrice)
    values.sellingPrice = parseFloat(values.sellingPrice);
  if (values.subtotal) values.subtotal = parseFloat(values.subtotal);

  return values;
};

module.exports = SaleItem;
