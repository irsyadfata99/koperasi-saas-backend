const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Supplier = sequelize.define(
  "Supplier",
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
    code: {
      type: DataTypes.STRING(20),
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    phone: {
      type: DataTypes.STRING(15),
      allowNull: true,
    },
    email: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },
    address: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
      field: "is_active",
    },
  },
  {
    tableName: "suppliers",
    timestamps: true,
    underscored: true,
    indexes: [{ unique: true, fields: ["client_id", "code"] }],
  },
);

Supplier.generateCode = async function (clientId) {
  const lastSupplier = await this.findOne({
    where: { clientId },
    order: [["code", "DESC"]],
  });

  let nextNumber = 1;
  if (lastSupplier) {
    const lastNumber = parseInt(lastSupplier.code.split("-")[1]) || 0;
    nextNumber = lastNumber + 1;
  }
  return `SUP-${String(nextNumber).padStart(3, "0")}`;
};

Supplier.findByCode = async function (clientId, code) {
  return await this.findOne({ where: { clientId, code } });
};

module.exports = Supplier;
