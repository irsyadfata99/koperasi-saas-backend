// src/seeders/seedSuppliers.js (FIXED FOR SAAS)
const { Supplier, Client } = require("../models");
const { sequelize } = require("../config/database");

const suppliers = [
  {
    code: "SUP-001",
    name: "PT Sumber Rezeki Jaya",
    phone: "081234567890",
    email: "admin@sumberrezeki.com",
    address: "Jl. Soekarno Hatta No. 123, Bandung",
    isActive: true,
  },
  {
    code: "SUP-002",
    name: "CV Maju Bersama",
    phone: "081987654321",
    email: "info@majubersama.id",
    address: "Jl. Jendral Sudirman No. 45, Jakarta",
    isActive: true,
  },
  {
    code: "SUP-003",
    name: "UD Barokah Selalu",
    phone: "085678901234",
    email: "sales@barokahselalu.com",
    address: "Pasar Induk Caringin Blok A1, Bandung",
    isActive: true,
  },
  {
    code: "SUP-004",
    name: "Toko Roti Keliling (Pak Ujang)",
    phone: "081345678901",
    email: null,
    address: "Jl. Kampung Rambutan, Bandung",
    isActive: true,
  },
  {
    code: "SUP-005",
    name: "Kerupuk Pasar (Bu Ema)",
    phone: "087712345678",
    email: null,
    address: "Pasar Kosambi Lantai Dasar, Bandung",
    isActive: true,
  },
  {
    code: "SUP-006",
    name: "PT Indo Food Distribusi",
    phone: "021-5556667",
    email: "distribusi@indofood.co.id",
    address: "Kawasan Industri Pulo Gadung, Jakarta",
    isActive: true,
  },
  {
    code: "SUP-007",
    name: "CV Tani Makmur",
    phone: "081122334455",
    email: "tani.makmur@gmail.com",
    address: "Lembang Asri No. 88, Bandung Barat",
    isActive: true,
  },
];

const seedSuppliers = async () => {
  try {
    console.log("🌱 Starting supplier seeding...");

    // 1. Cari Client ID dulu (WAJIB UTK SAAS)
    const client = await Client.findOne({ where: { code: "DEMO-01" } });
    if (!client) {
      throw new Error(
        "❌ Client 'DEMO-01' tidak ditemukan. Jalankan seed:admin dulu!",
      );
    }
    console.log(`Target Client: ${client.businessName} (${client.id})`);

    let createdCount = 0;
    let skippedCount = 0;
    let failedCount = 0;

    for (const data of suppliers) {
      try {
        // Cek duplicate berdasarkan kode & client
        const existing = await Supplier.findOne({
          where: {
            code: data.code,
            clientId: client.id,
          },
        });

        if (existing) {
          console.log(
            `⏭️  Skipped: ${data.name} (Code: ${data.code} already exists)`,
          );
          skippedCount++;
        } else {
          // Inject clientId ke data supplier
          await Supplier.create({
            ...data,
            clientId: client.id, // <--- INI KUNCINYA
          });
          console.log(`✅ Created: ${data.name}`);
          createdCount++;
        }
      } catch (err) {
        console.error(`❌ Error creating ${data.name}: ${err.message}`);
        failedCount++;
      }
    }

    console.log(
      "\n======================================================================",
    );
    console.log("📊 SEEDING SUMMARY");
    console.log(
      "======================================================================",
    );
    console.log(`✅ Successfully created: ${createdCount} suppliers`);
    console.log(`⏭️  Skipped (already exist): ${skippedCount} suppliers`);
    console.log(`❌ Failed: ${failedCount} suppliers`);
    console.log(
      "======================================================================",
    );
  } catch (error) {
    console.error("❌ Fatal Error:", error.message);
  }
};

// Execute if run directly
if (require.main === module) {
  seedSuppliers().then(() => {
    console.log("Done.");
    process.exit();
  });
}

module.exports = seedSuppliers;
