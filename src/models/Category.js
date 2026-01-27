// src/models/Category.js
const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Category = sequelize.define(
  "Category",
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
    name: {
      type: DataTypes.STRING(50),
      allowNull: false,
      validate: {
        notEmpty: { msg: "Nama kategori harus diisi" },
        len: { args: [3, 50], msg: "Nama kategori minimal 3 karakter" },
      },
    },
    description: {
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
    tableName: "categories",
    timestamps: true,
    underscored: true,
    indexes: [
      {
        unique: true,
        fields: ["client_id", "name"],
      },
    ],
  },
);

Category.prototype.toJSON = function () {
  const values = { ...this.get() };
  if (values.pointsMultiplier)
    values.pointsMultiplier = parseFloat(values.pointsMultiplier);
  return values;
};

module.exports = Category;
