// ============================================
// src/models/Setting.js
// PRODUCTION READY - Application Configuration Storage
// ============================================
const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/database");

const Setting = sequelize.define(
  "Setting",
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    // ✅ Wajib ada clientId
    clientId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "client_id",
    },
    key: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    value: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    // ✅ Kolom yang baru kita tambah lagi
    type: {
      type: DataTypes.ENUM("TEXT", "NUMBER", "BOOLEAN", "JSON"),
      defaultValue: "TEXT",
    },
    group: {
      type: DataTypes.STRING(50),
      defaultValue: "GENERAL",
    },
    description: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
  },
  {
    tableName: "settings",
    timestamps: true,
    underscored: true,
    indexes: [
      // Unik per Client
      { unique: true, fields: ["client_id", "key"] },
    ],
  },
);

// ============================================
// INSTANCE METHODS
// ============================================

/**
 * Get parsed value based on type
 */
Setting.prototype.getParsedValue = function () {
  if (!this.value) return null;

  switch (this.type) {
    case "NUMBER":
      return parseFloat(this.value);
    case "BOOLEAN":
      return this.value === "true" || this.value === "1";
    case "JSON":
      try {
        return JSON.parse(this.value);
      } catch (e) {
        return null;
      }
    case "TEXT":
    default:
      return this.value;
  }
};

/**
 * Get formatted data for response
 */
Setting.prototype.toJSON = function () {
  const values = { ...this.get() };
  values.parsedValue = this.getParsedValue();
  return values;
};

// ============================================
// STATIC METHODS
// ============================================

/**
 * Get setting value by key
 */
Setting.get = async function (key, clientId, defaultValue = null) {
  if (!clientId) throw new Error("ClientId required for Setting.get");
  const setting = await this.findOne({ where: { key, clientId } });
  if (!setting) return defaultValue;
  return setting.getParsedValue();
};

/**
 * Set setting value
 */
Setting.set = async function (
  key,
  value,
  clientId, // ✅ Add clientId
  type = "TEXT",
  group = "GENERAL",
  description = null,
) {
  if (!clientId) throw new Error("ClientId required for Setting.set");

  const stringValue =
    typeof value === "object" ? JSON.stringify(value) : String(value);

  const [setting] = await this.findOrCreate({
    where: { key, clientId }, // ✅ Scope by client
    defaults: {
      clientId,
      key,
      value: stringValue,
      type,
      group,
      description,
    },
  });

  if (setting.value !== stringValue) {
    await setting.update({ value: stringValue, type, group, description });
  }

  return setting;
};

/**
 * Initialize default settings
 * @param {string} clientId - Client UUID
 * @param {object} clientData - Optional client data { businessName, address, phone }
 */
Setting.initializeDefaults = async function (clientId, clientData = {}) {
  if (!clientId) throw new Error("ClientId required for initializeDefaults");

  // ✅ Use client data if available, otherwise use placeholder
  const companyName = clientData.businessName || "Nama Toko Anda";
  const companyAddress = clientData.address || "Alamat Toko Anda";
  const companyPhone = clientData.phone || "Telepon Anda";

  const defaults = [
    // ===== COMPANY INFO =====
    {
      key: "company_name",
      value: companyName, // ✅ Dynamic from client data
      type: "TEXT",
      group: "COMPANY",
      description: "Nama perusahaan",
    },
    {
      key: "company_address",
      value: companyAddress, // ✅ Dynamic from client data
      type: "TEXT",
      group: "COMPANY",
      description: "Alamat perusahaan",
    },
    {
      key: "company_phone",
      value: companyPhone, // ✅ Dynamic from client data
      type: "TEXT",
      group: "COMPANY",
      description: "Nomor telepon perusahaan",
    },
    {
      key: "company_website",
      value: "",
      type: "TEXT",
      group: "COMPANY",
      description: "Website perusahaan",
    },
    {
      key: "company_city",
      value: "",
      type: "TEXT",
      group: "COMPANY",
      description: "Kota perusahaan",
    },

    // ===== BANK INFO =====
    {
      key: "bank_name",
      value: "",
      type: "TEXT",
      group: "BANK",
      description: "Nama bank",
    },
    {
      key: "bank_account_number",
      value: "",
      type: "TEXT",
      group: "BANK",
      description: "Nomor rekening bank",
    },
    {
      key: "bank_account_name",
      value: companyName, // ✅ Use company name as default
      type: "TEXT",
      group: "BANK",
      description: "Nama pemilik rekening",
    },

    // ===== TRANSACTION SETTINGS =====
    {
      key: "default_credit_days",
      value: "30",
      type: "NUMBER",
      group: "TRANSACTION",
      description: "Jangka waktu kredit default (hari)",
    },
    {
      key: "min_credit_dp_percentage",
      value: "20",
      type: "NUMBER",
      group: "TRANSACTION",
      description: "Minimal DP untuk kredit (%)",
    },
    {
      key: "point_per_rupiah",
      value: "1000",
      type: "NUMBER",
      group: "TRANSACTION",
      description: "Poin per rupiah (1 poin per 1000 rupiah)",
    },
    {
      key: "point_enabled",
      value: "true",
      type: "BOOLEAN",
      group: "TRANSACTION",
      description: "Enable/disable sistem point",
    },
    {
      key: "min_transaction_for_points",
      value: "50000",
      type: "NUMBER",
      group: "TRANSACTION",
      description: "Minimum transaksi untuk dapat point",
    },
    {
      key: "point_expiry_months",
      value: "12",
      type: "NUMBER",
      group: "TRANSACTION",
      description: "Masa berlaku point (bulan)",
    },
    {
      key: "min_points_to_redeem",
      value: "100",
      type: "NUMBER",
      group: "TRANSACTION",
      description: "Minimum point untuk ditukar",
    },
    {
      key: "point_value",
      value: "1000",
      type: "NUMBER",
      group: "TRANSACTION",
      description: "Nilai point dalam rupiah (1 point = X rupiah)",
    },
    {
      key: "auto_print_after_sale",
      value: "true",
      type: "BOOLEAN",
      group: "PRINT",
      description: "Auto print setelah transaksi",
    },

    // ===== PRINT SETTINGS =====
    {
      key: "print_thermal_width",
      value: "58",
      type: "NUMBER",
      group: "PRINT",
      description: "Lebar kertas thermal (mm)",
    },
    {
      key: "print_dot_matrix_width",
      value: "80",
      type: "NUMBER",
      group: "PRINT",
      description: "Lebar karakter dot matrix",
    },
    {
      key: "print_show_barcode",
      value: "true",
      type: "BOOLEAN",
      group: "PRINT",
      description: "Tampilkan barcode di struk",
    },

    // ===== LOW STOCK ALERT =====
    {
      key: "low_stock_alert_threshold",
      value: "10",
      type: "NUMBER",
      group: "INVENTORY",
      description: "Batas minimal stok untuk alert",
    },
    {
      key: "auto_reorder_enabled",
      value: "false",
      type: "BOOLEAN",
      group: "INVENTORY",
      description: "Auto reorder saat stok menipis",
    },
  ];

  const results = [];

  for (const setting of defaults) {
    try {
      const created = await this.set(
        setting.key,
        setting.value,
        clientId, // ✅ Pass clientId
        setting.type,
        setting.group,
        setting.description,
      );
      results.push(created);
    } catch (error) {
      console.error(`Error creating setting ${setting.key}:`, error.message);
    }
  }

  console.log(`✅ Initialized ${results.length} default settings`);
  return results;
};

/**
 * Get all settings grouped
 */
Setting.getAllGrouped = async function (clientId) {
  const settings = await this.findAll({
    where: { clientId }, // ✅ Filter by client
    order: [
      ["group", "ASC"],
      ["key", "ASC"],
    ],
  });

  const grouped = {};
  settings.forEach((setting) => {
    if (!grouped[setting.group]) {
      grouped[setting.group] = {};
    }
    grouped[setting.group][setting.key] = setting.getParsedValue();
  });

  return grouped;
};

/**
 * Get all settings by group
 */
Setting.getByGroup = async function (group, clientId) {
  const settings = await this.findAll({
    where: { group, clientId }, // ✅ Filter by client
    order: [["key", "ASC"]],
  });

  const result = {};
  settings.forEach((setting) => {
    result[setting.key] = setting.getParsedValue();
  });

  return result;
};

/**
 * Bulk update settings
 */
Setting.bulkUpdate = async function (updates, clientId) {
  if (!clientId) throw new Error("ClientId required for bulkUpdate");
  const results = [];

  for (const [key, value] of Object.entries(updates)) {
    try {
      const setting = await this.findOne({ where: { key, clientId } });

      if (setting) {
        const stringValue =
          typeof value === "object" ? JSON.stringify(value) : String(value);
        await setting.update({ value: stringValue });
        results.push({ key, success: true });
      } else {
        results.push({ key, success: false, error: "Setting not found" });
      }
    } catch (error) {
      results.push({ key, success: false, error: error.message });
    }
  }

  return results;
};

module.exports = Setting;
