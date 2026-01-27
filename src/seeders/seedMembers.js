// src/seeders/seedMembers.js (FIXED: AUTO-UPDATE TABLE SCHEMA)
const { sequelize } = require("../config/database");
const Member = require("../models/Member");
const Client = require("../models/Client");
require("dotenv").config();

// Data member dummy untuk setiap region
const memberData = [
  // Region: Bandung (BDG)
  {
    nik: "3273010101900001",
    fullName: "Ahmad Hidayat",
    address: "Jl. Merdeka No. 123, Bandung",
    regionCode: "BDG",
    whatsapp: "081234567890",
    gender: "Laki-laki",
  },
  {
    nik: "3273010201900002",
    fullName: "Siti Nurhaliza",
    address: "Jl. Sudirman No. 456, Bandung",
    regionCode: "BDG",
    whatsapp: "082345678901",
    gender: "Perempuan",
  },
  {
    nik: "3273010301900003",
    fullName: "Budi Santoso",
    address: "Jl. Asia Afrika No. 789, Bandung",
    regionCode: "BDG",
    whatsapp: "083456789012",
    gender: "Laki-laki",
  },
  // Region: Kabupaten Bandung (KBG)
  {
    nik: "3204010101900004",
    fullName: "Dewi Lestari",
    address: "Jl. Raya Soreang No. 100, Kabupaten Bandung",
    regionCode: "KBG",
    whatsapp: "084567890123",
    gender: "Perempuan",
  },
  {
    nik: "3204010201900005",
    fullName: "Eko Prasetyo",
    address: "Jl. Raya Majalaya No. 200, Kabupaten Bandung",
    regionCode: "KBG",
    whatsapp: "085678901234",
    gender: "Laki-laki",
  },
];

const seedMembers = async () => {
  try {
    console.log("🌱 Starting member seeding...\n");

    await sequelize.authenticate();
    console.log("✅ Database connected\n");

    // 1. Cari Client ID (WAJIB SAAS)
    const client = await Client.findOne({ where: { code: "DEMO-01" } });
    if (!client) {
      throw new Error(
        "❌ Client 'DEMO-01' tidak ditemukan. Jalankan seed:admin dulu!",
      );
    }
    console.log(`Target Client: ${client.businessName} (${client.id})\n`);

    // ✅ FIX: Gunakan 'alter: true' agar kolom region_code ditambahkan otomatis ke DB
    console.log("🔄 Updating table schema...");
    await sequelize.sync({ alter: true });
    console.log("✅ Table schema updated (columns added)\n");

    console.log(`📝 Creating ${memberData.length} members...\n`);

    let successCount = 0;
    let errorCount = 0;

    for (const data of memberData) {
      try {
        // Check if NIK already exists (Per Client)
        const existingNik = await Member.findOne({
          where: {
            nik: data.nik,
            clientId: client.id,
          },
        });

        if (existingNik) {
          console.log(`⏭️  Skipped: ${data.fullName} (NIK already exists)`);
          continue;
        }

        // Generate unique ID
        const uniqueId = await Member.generateUniqueId(
          data.regionCode,
          client.id,
        );

        const REGIONS = {
          BDG: "Bandung",
          KBG: "Kabupaten Bandung",
          KBB: "Kabupaten Bandung Barat",
          KBT: "Kabupaten Bandung Timur",
          CMH: "Cimahi",
          GRT: "Garut",
          SMD: "Sumedang",
          TSM: "Tasikmalaya",
          SMI: "Kota Sukabumi",
          CJR: "Cianjur",
          BGR: "Bogor",
        };
        const regionName = REGIONS[data.regionCode] || "Jawa Barat";

        // Create member (Inject Client ID)
        const member = await Member.create({
          clientId: client.id, // ✅ PENTING
          uniqueId,
          nik: data.nik,
          fullName: data.fullName,
          address: data.address,
          regionCode: data.regionCode,
          regionName: regionName,
          whatsapp: data.whatsapp,
          gender: data.gender,
          totalDebt: 0,
          totalTransactions: 0,
          monthlySpending: 0,
          totalPoints: 0,
          isActive: true,
        });

        console.log(`✅ Created: ${member.uniqueId} - ${member.fullName}`);
        successCount++;
      } catch (error) {
        console.error(`❌ Error creating ${data.fullName}:`, error.message);
        errorCount++;
      }
    }

    console.log("\n" + "=".repeat(60));
    console.log("📊 SEEDING SUMMARY");
    console.log("=".repeat(60));
    console.log(`✅ Successfully created: ${successCount} members`);
    console.log(`❌ Failed: ${errorCount} members`);
    console.log("=".repeat(60) + "\n");

    process.exit(0);
  } catch (error) {
    console.error("\n❌ Error during seeding:", error);
    process.exit(1);
  }
};

// Run seeder
seedMembers();
