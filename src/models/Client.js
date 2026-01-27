const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Client = sequelize.define(
  "Client",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    code: {
      type: DataTypes.STRING(20),
      allowNull: false,
      unique: {
        msg: "Kode perusahaan sudah digunakan",
      },
    },
    businessName: {
      type: DataTypes.STRING(100),
      allowNull: false,
      field: "business_name", // Mapping ke snake_case di DB
    },
    ownerName: {
      type: DataTypes.STRING(100),
      allowNull: true,
      field: "owner_name",
    },
    phone: {
      type: DataTypes.STRING(20),
      allowNull: true,
    },
    address: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    status: {
      type: DataTypes.ENUM("ACTIVE", "SUSPENDED", "INACTIVE"),
      defaultValue: "ACTIVE",
    },
    subscriptionPlan: {
      type: DataTypes.ENUM("FREE", "BASIC", "PREMIUM"),
      defaultValue: "FREE",
      field: "subscription_plan",
    },
    subscriptionEnd: {
      type: DataTypes.DATE,
      allowNull: true,
      field: "subscription_end",
    },
  },
  {
    tableName: "clients", // Sesuaikan nama tabel di SQL
    timestamps: true,
    underscored: true,
  },
);

module.exports = Client;
