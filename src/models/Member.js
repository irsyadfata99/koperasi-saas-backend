// ============================================
// src/models/Member.js (SAAS VERSION - FINAL)
// ============================================
const { DataTypes, Op } = require("sequelize");
const { sequelize } = require("../config/database");

const Member = sequelize.define(
  "Member",
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
    uniqueId: {
      type: DataTypes.STRING(20),
      allowNull: false,
      field: "unique_id",
    },
    nik: {
      type: DataTypes.STRING(16),
      allowNull: false,
    },
    fullName: {
      type: DataTypes.STRING(100),
      allowNull: false,
      field: "full_name",
    },
    address: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    regionCode: {
      type: DataTypes.STRING(5),
      allowNull: false,
      field: "region_code",
    },
    regionName: {
      type: DataTypes.STRING(50),
      allowNull: true,
      field: "region_name",
    },
    whatsapp: {
      type: DataTypes.STRING(15),
      allowNull: true,
    },
    gender: {
      type: DataTypes.ENUM("Laki-laki", "Perempuan"),
      allowNull: true,
    },
    totalPoints: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      field: "total_points",
    },
    totalDebt: {
      type: DataTypes.DECIMAL(15, 2),
      defaultValue: 0,
      field: "total_debt",
    },
    totalTransactions: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      field: "total_transactions",
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
      field: "is_active",
    },
  },
  {
    tableName: "members",
    timestamps: true,
    underscored: true,
    indexes: [
      // Unik per Client (NIK & ID Member)
      { unique: true, fields: ["client_id", "unique_id"] },
      { unique: true, fields: ["client_id", "nik"] },
      { fields: ["client_id", "full_name"] },
    ],
  },
);

// ============================================
// STATIC METHODS
// ============================================

// ✅ Logic Generate ID (Support Client & Region)
Member.generateUniqueId = async function (regionCode, clientId) {
  // Format: REG-YYYY-XXXX (Contoh: BDG-2025-0001)
  const year = new Date().getFullYear();
  const prefix = `${regionCode}-${year}`;

  const lastMember = await this.findOne({
    where: {
      clientId, // Filter by Client
      uniqueId: { [Op.like]: `${prefix}-%` },
    },
    order: [["uniqueId", "DESC"]],
  });

  let nextNumber = 1;
  if (lastMember) {
    const parts = lastMember.uniqueId.split("-");
    // Ambil bagian terakhir (XXXX)
    nextNumber = (parseInt(parts[parts.length - 1]) || 0) + 1;
  }

  // Gabungkan: BDG-2025-0001
  return `${prefix}-${String(nextNumber).padStart(4, "0")}`;
};

// ============================================
// INSTANCE METHODS
// ============================================

Member.prototype.toJSON = function () {
  const values = { ...this.get() };
  if (values.totalDebt) values.totalDebt = parseFloat(values.totalDebt);
  return values;
};

module.exports = Member;
