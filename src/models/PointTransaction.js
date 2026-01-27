// src/models/PointTransaction.js
// ============================================
// FIX: Added clientId to models AND static methods
// ============================================
const { DataTypes, Op } = require("sequelize");
const { sequelize } = require("../config/database");

const PointTransaction = sequelize.define(
  "PointTransaction",
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
      allowNull: true,
      field: "sale_id",
    },
    type: {
      type: DataTypes.ENUM("EARN", "REDEEM", "ADJUSTMENT", "EXPIRED"),
      allowNull: false,
    },
    points: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        notZero: (v) => {
          if (v === 0) throw new Error("Points tidak boleh 0");
        },
      },
    },
    pointsBefore: { type: DataTypes.INTEGER, field: "points_before" },
    pointsAfter: { type: DataTypes.INTEGER, field: "points_after" },
    description: DataTypes.STRING(255),
    expiryDate: { type: DataTypes.DATE, field: "expiry_date" },
    isExpired: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
      field: "is_expired",
    },
    createdBy: { type: DataTypes.UUID, field: "created_by" },
    notes: DataTypes.TEXT,
  },
  {
    tableName: "point_transactions",
    timestamps: true,
    underscored: true,
    indexes: [
      { fields: ["client_id", "member_id"] },
      { fields: ["client_id", "type"] },
    ],
  },
);

// ============================================
// INSTANCE METHODS (TETAP ADA)
// ============================================

PointTransaction.prototype.checkExpiry = function () {
  if (this.type !== "EARN" || !this.expiryDate) return false;
  return new Date() > new Date(this.expiryDate);
};

PointTransaction.prototype.getDaysUntilExpiry = function () {
  if (this.type !== "EARN" || !this.expiryDate) return null;
  if (this.isExpired) return 0;
  const diffTime = new Date(this.expiryDate) - new Date();
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  return diffDays > 0 ? diffDays : 0;
};

PointTransaction.prototype.toJSON = function () {
  const values = { ...this.get() };
  if (this.type === "EARN") values.daysUntilExpiry = this.getDaysUntilExpiry();
  return values;
};

// ============================================
// STATIC METHODS (DIPERBARUI)
// ============================================

PointTransaction.recordEarn = async function (
  memberId,
  saleId,
  points,
  description,
  transaction = null,
) {
  const Member = require("./Member");
  const member = await Member.findByPk(memberId, { transaction });
  if (!member) throw new Error("Member tidak ditemukan");

  const pointsBefore = member.totalPoints;
  const pointsAfter = pointsBefore + points;

  // Get expiry from settings (skipped for now, default 12 months)
  const expiryDate = new Date();
  expiryDate.setMonth(expiryDate.getMonth() + 12);

  const pointTrx = await this.create(
    {
      clientId: member.clientId, // ✅ Ambil dari Member
      memberId,
      saleId,
      type: "EARN",
      points,
      pointsBefore,
      pointsAfter,
      description,
      expiryDate,
      isExpired: false,
    },
    { transaction },
  );

  member.totalPoints = pointsAfter;
  await member.save({ transaction });

  return pointTrx;
};

PointTransaction.recordRedeem = async function (
  memberId,
  points,
  description,
  userId,
  transaction = null,
) {
  const Member = require("./Member");
  const member = await Member.findByPk(memberId, { transaction });
  if (!member) throw new Error("Member tidak ditemukan");
  if (member.totalPoints < points)
    throw new Error(`Point tidak cukup. Tersedia: ${member.totalPoints}`);

  const pointsBefore = member.totalPoints;
  const pointsAfter = pointsBefore - points;

  const pointTrx = await this.create(
    {
      clientId: member.clientId, // ✅ Ambil dari Member
      memberId,
      saleId: null,
      type: "REDEEM",
      points: -points,
      pointsBefore,
      pointsAfter,
      description,
      createdBy: userId,
    },
    { transaction },
  );

  member.totalPoints = pointsAfter;
  await member.save({ transaction });
  return pointTrx;
};

PointTransaction.recordAdjustment = async function (
  memberId,
  points,
  description,
  userId,
  notes = null,
  transaction = null,
) {
  const Member = require("./Member");
  const member = await Member.findByPk(memberId, { transaction });
  if (!member) throw new Error("Member tidak ditemukan");

  const pointsBefore = member.totalPoints;
  const pointsAfter = pointsBefore + points;
  if (pointsAfter < 0) throw new Error(`Adjustment gagal. Point akan negatif.`);

  const pointTrx = await this.create(
    {
      clientId: member.clientId, // ✅ Ambil dari Member
      memberId,
      type: "ADJUSTMENT",
      points,
      pointsBefore,
      pointsAfter,
      description,
      createdBy: userId,
      notes,
    },
    { transaction },
  );

  member.totalPoints = pointsAfter;
  await member.save({ transaction });
  return pointTrx;
};

module.exports = PointTransaction;
