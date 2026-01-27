// src/seeders/seedSettings.js (SAAS READY)
const { sequelize } = require("../config/database");
const Setting = require("../models/Setting");
const Client = require("../models/Client");
require("dotenv").config();

const seedSettings = async () => {
  try {
    console.log("🌱 Starting settings seeding...");
    await sequelize.authenticate();

    // 1. CARI CLIENT TARGET
    const client = await Client.findOne({ where: { code: "DEMO-01" } });
    if (!client) throw new Error("❌ Client 'DEMO-01' not found!");

    // Data settings default (Saya sederhanakan contohnya)
    const settings = [
      {
        key: "company_name",
        value: client.businessName,
        type: "TEXT",
        group: "COMPANY",
      },
      {
        key: "company_address",
        value: client.address,
        type: "TEXT",
        group: "COMPANY",
      },
      {
        key: "company_phone",
        value: client.phone,
        type: "TEXT",
        group: "COMPANY",
      },
      {
        key: "print_show_barcode",
        value: "true",
        type: "BOOLEAN",
        group: "PRINT",
      },
      {
        key: "low_stock_alert_threshold",
        value: "10",
        type: "NUMBER",
        group: "INVENTORY",
      },
      { key: "point_enabled", value: "true", type: "BOOLEAN", group: "POINTS" },
    ];

    console.log(`Target Client: ${client.businessName}\n`);
    let successCount = 0;

    for (const data of settings) {
      // Logic Upsert (Update if exists, Create if not)
      const existing = await Setting.findOne({
        where: { clientId: client.id, key: data.key },
      });

      if (existing) {
        // Update value
        existing.value = data.value;
        await existing.save();
        console.log(`updated: ${data.key}`);
      } else {
        // Create new
        await Setting.create({
          clientId: client.id, // ✅ Wajib
          key: data.key,
          value: data.value,
          type: data.type,
          group: data.group,
          description: data.description || "",
        });
        successCount++;
        console.log(`created: ${data.key}`);
      }
    }

    console.log(`\n🎉 Settings seeded for ${client.businessName}`);
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error);
    process.exit(1);
  }
};

seedSettings();
