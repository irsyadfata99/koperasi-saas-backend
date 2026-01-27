// src/models/MemberDebt.js
// ============================================
// FIX: Added clientId to models AND addPayment method
// ============================================
const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

// ============================================
// MODEL: MEMBER DEBT
// ============================================
const MemberDebt = sequelize.define(
  "MemberDebt",
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
    memberId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "member_id",
    },
    saleId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "sale_id",
    },
    invoiceNumber: {
      type: DataTypes.STRING(50),
      allowNull: false,
      field: "invoice_number",
    },
    totalAmount: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      field: "total_amount",
      validate: { min: 0 },
    },
    paidAmount: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      defaultValue: 0,
      field: "paid_amount",
      validate: { min: 0 },
    },
    remainingAmount: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      field: "remaining_amount",
      validate: { min: 0 },
    },
    dueDate: {
      type: DataTypes.DATE,
      allowNull: false,
      field: "due_date",
    },
    status: {
      type: DataTypes.ENUM("PENDING", "PARTIAL", "PAID", "OVERDUE"),
      allowNull: false,
      defaultValue: "PENDING",
    },
    notes: DataTypes.TEXT,
  },
  {
    tableName: "member_debts",
    timestamps: true,
    underscored: true,
    indexes: [
      { fields: ["client_id", "member_id"] },
      { fields: ["client_id", "status"] },
    ],
  },
);

// ============================================
// MODEL: DEBT PAYMENT
// ============================================
const DebtPayment = sequelize.define(
  "DebtPayment",
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
    memberDebtId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "member_debt_id",
    },
    memberId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "member_id",
    },
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "user_id",
      comment: "User yang menerima pembayaran",
    },
    amount: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      validate: { min: 0 },
    },
    paymentMethod: {
      type: DataTypes.ENUM("CASH", "TRANSFER", "DEBIT", "CREDIT"),
      allowNull: false,
      defaultValue: "CASH",
      field: "payment_method",
    },
    paymentDate: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
      field: "payment_date",
    },
    receiptNumber: {
      type: DataTypes.STRING(50),
      allowNull: true,
      field: "receipt_number",
    },
    notes: DataTypes.TEXT,
  },
  {
    tableName: "debt_payments",
    timestamps: true,
    underscored: true,
    indexes: [
      { fields: ["client_id", "member_debt_id"] },
      { fields: ["client_id", "payment_date"] },
    ],
  },
);

// ============================================
// INSTANCE METHODS (TETAP ADA)
// ============================================

MemberDebt.prototype.isOverdue = function () {
  if (this.status === "PAID") return false;
  return new Date() > new Date(this.dueDate);
};

MemberDebt.prototype.getDaysOverdue = function () {
  if (!this.isOverdue()) return 0;
  const today = new Date();
  const dueDate = new Date(this.dueDate);
  const diffTime = Math.abs(today - dueDate);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
};

MemberDebt.prototype.getPaymentPercentage = function () {
  if (this.totalAmount === 0) return 100;
  return ((this.paidAmount / this.totalAmount) * 100).toFixed(2);
};

// ✅ FIX: method addPayment menyertakan clientId
MemberDebt.prototype.addPayment = async function (
  amount,
  userId,
  paymentMethod = "CASH",
  notes = null,
) {
  if (amount <= 0) throw new Error("Jumlah pembayaran harus lebih dari 0");
  if (amount > this.remainingAmount)
    throw new Error(`Pembayaran melebihi sisa hutang.`);

  // Create payment record (Include clientId)
  const payment = await DebtPayment.create({
    clientId: this.clientId, // <--- PENTING!
    memberDebtId: this.id,
    memberId: this.memberId,
    userId: userId,
    amount: amount,
    paymentMethod: paymentMethod,
    paymentDate: new Date(),
    notes: notes,
  });

  // Update debt amounts
  this.paidAmount = parseFloat(this.paidAmount) + amount;
  this.remainingAmount =
    parseFloat(this.totalAmount) - parseFloat(this.paidAmount);

  if (this.remainingAmount <= 0) {
    this.status = "PAID";
    this.remainingAmount = 0;
  } else {
    this.status = "PARTIAL";
  }

  await this.save();

  // Update member's total debt
  const Member = sequelize.models.Member;
  const member = await Member.findByPk(this.memberId);
  if (member) {
    member.totalDebt = Math.max(0, parseFloat(member.totalDebt) - amount);
    await member.save();
  }

  return payment;
};

MemberDebt.prototype.toJSON = function () {
  const values = { ...this.get() };
  values.totalAmount = parseFloat(values.totalAmount);
  values.paidAmount = parseFloat(values.paidAmount);
  values.remainingAmount = parseFloat(values.remainingAmount);
  values.isOverdue = this.isOverdue();
  values.daysOverdue = this.getDaysOverdue();
  values.paymentPercentage = this.getPaymentPercentage();
  return values;
};

DebtPayment.prototype.toJSON = function () {
  const values = { ...this.get() };
  values.amount = parseFloat(values.amount);
  return values;
};

module.exports = { MemberDebt, DebtPayment };
