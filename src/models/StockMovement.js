// src/models/StockMovement.js
// ============================================
// FIX: Added clientId to models AND static methods
// ============================================
const { DataTypes, Op } = require("sequelize");
const { sequelize } = require("../config/database");

// === MODEL 1: STOCK MOVEMENT ===
const StockMovement = sequelize.define(
  "StockMovement",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    // ✅ NEW: CLIENT ID
    clientId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "client_id",
    },
    productId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "product_id",
    },
    type: {
      type: DataTypes.ENUM(
        "IN",
        "OUT",
        "ADJUSTMENT",
        "RETURN_IN",
        "RETURN_OUT",
      ),
      allowNull: false,
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    quantityBefore: { type: DataTypes.INTEGER, field: "quantity_before" },
    quantityAfter: { type: DataTypes.INTEGER, field: "quantity_after" },
    referenceType: {
      type: DataTypes.ENUM("PURCHASE", "SALE", "ADJUSTMENT", "RETURN"),
      field: "reference_type",
    },
    referenceId: { type: DataTypes.UUID, field: "reference_id" },
    notes: DataTypes.TEXT,
    createdBy: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "created_by",
    },
  },
  {
    tableName: "stock_movements",
    timestamps: true,
    underscored: true,
  },
);

// === MODEL 2: STOCK ADJUSTMENT ===
const StockAdjustment = sequelize.define(
  "StockAdjustment",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    // ✅ NEW: CLIENT ID
    clientId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "client_id",
    },
    productId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "product_id",
    },
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "user_id",
    },
    adjustmentNumber: {
      type: DataTypes.STRING(50),
      allowNull: false,
      field: "adjustment_number",
    },
    adjustmentType: {
      type: DataTypes.ENUM(
        "DAMAGED",
        "EXPIRED",
        "LOST",
        "LEAKED",
        "REPACK",
        "FOUND",
        "OTHER",
      ),
      allowNull: false,
      field: "adjustment_type",
    },
    quantity: DataTypes.INTEGER,
    reason: DataTypes.TEXT,
    adjustmentDate: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
      field: "adjustment_date",
    },
    notes: DataTypes.TEXT,
    approvedBy: { type: DataTypes.UUID, field: "approved_by" },
    status: {
      type: DataTypes.ENUM("PENDING", "APPROVED", "REJECTED"),
      defaultValue: "APPROVED",
    },
  },
  {
    tableName: "stock_adjustments",
    timestamps: true,
    underscored: true,
    indexes: [{ unique: true, fields: ["client_id", "adjustment_number"] }],
  },
);

// ============================================
// STATIC METHODS (TETAP ADA & DIPERBARUI)
// ============================================

StockMovement.recordIn = async function (
  productId,
  quantity,
  referenceId,
  userId,
  notes = null,
) {
  const Product = sequelize.models.Product;
  const product = await Product.findByPk(productId);
  if (!product) throw new Error("Produk tidak ditemukan");

  const quantityBefore = product.stock;
  await product.addStock(quantity);
  const quantityAfter = product.stock;

  return await this.create({
    clientId: product.clientId, // ✅ Ambil dari Produk
    productId,
    type: "IN",
    quantity,
    quantityBefore,
    quantityAfter,
    referenceType: "PURCHASE",
    referenceId,
    notes,
    createdBy: userId,
  });
};

StockMovement.recordOut = async function (
  productId,
  quantity,
  referenceId,
  userId,
  notes = null,
) {
  const Product = sequelize.models.Product;
  const product = await Product.findByPk(productId);
  if (!product) throw new Error("Produk tidak ditemukan");

  const quantityBefore = product.stock;
  await product.reduceStock(quantity);
  const quantityAfter = product.stock;

  return await this.create({
    clientId: product.clientId, // ✅ Ambil dari Produk
    productId,
    type: "OUT",
    quantity: -quantity,
    quantityBefore,
    quantityAfter,
    referenceType: "SALE",
    referenceId,
    notes,
    createdBy: userId,
  });
};

StockMovement.recordAdjustment = async function (
  productId,
  quantity,
  adjustmentId,
  userId,
  notes = null,
) {
  const Product = sequelize.models.Product;
  const product = await Product.findByPk(productId);
  if (!product) throw new Error("Produk tidak ditemukan");

  const quantityBefore = product.stock;
  if (quantity > 0) await product.addStock(quantity);
  else await product.reduceStock(Math.abs(quantity));
  const quantityAfter = product.stock;

  return await this.create({
    clientId: product.clientId, // ✅ Ambil dari Produk
    productId,
    type: "ADJUSTMENT",
    quantity,
    quantityBefore,
    quantityAfter,
    referenceType: "ADJUSTMENT",
    referenceId: adjustmentId,
    notes,
    createdBy: userId,
  });
};

// ============================================
// STATIC METHODS - STOCK ADJUSTMENT
// ============================================

StockAdjustment.generateAdjustmentNumber = async function (clientId) {
  const dateStr = new Date().toISOString().slice(0, 10).replace(/-/g, ""); // YYYYMMDD
  const lastAdj = await this.findOne({
    where: {
      clientId,
      adjustmentNumber: { [Op.like]: `ADJ-${dateStr}-%` },
    },
    order: [["adjustmentNumber", "DESC"]],
  });

  let nextNum = 1;
  if (lastAdj) {
    const parts = lastAdj.adjustmentNumber.split("-");
    nextNum = (parseInt(parts[2]) || 0) + 1;
  }
  return `ADJ-${dateStr}-${String(nextNum).padStart(3, "0")}`;
};

StockAdjustment.createAndApply = async function (data) {
  const { productId, userId, adjustmentType, quantity, reason, notes } = data;

  // Ambil Client ID dari Produk
  const Product = sequelize.models.Product;
  const product = await Product.findByPk(productId);
  if (!product) throw new Error("Produk tidak ditemukan");

  // Generate Number per Client
  const adjustmentNumber = await this.generateAdjustmentNumber(
    product.clientId,
  );

  const adjustment = await this.create({
    clientId: product.clientId, // ✅ Assign Client
    adjustmentNumber,
    productId,
    userId,
    adjustmentType,
    quantity,
    reason,
    notes,
    status: "APPROVED",
  });

  await StockMovement.recordAdjustment(
    productId,
    quantity,
    adjustment.id,
    userId,
    `${adjustmentType}: ${reason}`,
  );

  return adjustment;
};

StockAdjustment.prototype.toJSON = function () {
  return { ...this.get() };
};

module.exports = { StockMovement, StockAdjustment };
