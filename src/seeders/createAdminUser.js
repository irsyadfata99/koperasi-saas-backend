// src/seeders/createAdminUser.js (SAAS READY)
const { sequelize } = require("../config/database");
const User = require("../models/User");
const Client = require("../models/Client"); // ✅ Wajib Import Client
require("dotenv").config();

const createSaaSData = async () => {
  try {
    await sequelize.authenticate();
    console.log("✅ Database connected");
    await sequelize.sync({ force: false });

    // 1. BUAT CLIENT DEMO (Toko Penyewa Pertama)
    // ------------------------------------------
    let client = await Client.findOne({ where: { code: "DEMO-01" } });

    if (!client) {
      client = await Client.create({
        code: "DEMO-01",
        businessName: "Koperasi Demo Sejahtera", // Toko Contoh
        ownerName: "Budi Santoso",
        phone: "08123456789",
        address: "Jl. Teknologi No. 1, Bandung",
        status: "ACTIVE",
        subscriptionPlan: "PREMIUM",
      });
      console.log("✅ Client 'Koperasi Demo' created!");
    } else {
      console.log("ℹ️  Client 'Koperasi Demo' already exists.");
    }

    // 2. BUAT SUPER ADMIN (Pemilik SaaS - Kamu)
    // ------------------------------------------
    // Client ID = NULL (Karena dia tidak terikat toko manapun)
    const superAdminExists = await User.findOne({
      where: { email: "super@saas.com" },
    });

    if (!superAdminExists) {
      await User.create({
        clientId: null, // ✅ KUNCI SUPER ADMIN
        username: "superadmin",
        email: "super@saas.com",
        name: "Super Administrator",
        password: "Super@123",
        role: "SUPER_ADMIN", // Pastikan enum role di User.js sudah ada SUPER_ADMIN ya!
        isActive: true,
      });
      console.log("✅ Super Admin created (super@saas.com)");
    }

    // 3. BUAT ADMIN TOKO (Milik Client Demo)
    // ------------------------------------------
    const adminExists = await User.findOne({
      where: { username: "admin", clientId: client.id },
    });

    if (!adminExists) {
      await User.create({
        clientId: client.id, // ✅ Terikat ke Toko Demo
        username: "admin",
        email: "admin@koperasi.com",
        name: "Admin Koperasi",
        password: "Admin@123",
        role: "ADMIN",
        isActive: true,
      });
      console.log("✅ Client Admin created (admin@koperasi.com)");
    }

    // 4. BUAT KASIR TOKO (Milik Client Demo)
    // ------------------------------------------
    const kasirExists = await User.findOne({
      where: { username: "kasir", clientId: client.id },
    });

    if (!kasirExists) {
      await User.create({
        clientId: client.id, // ✅ Terikat ke Toko Demo
        username: "kasir",
        email: "kasir@koperasi.com",
        name: "Kasir Koperasi",
        password: "Kasir@123",
        role: "KASIR",
        isActive: true,
      });
      console.log("✅ Client Kasir created (kasir@koperasi.com)");
    }

    console.log("\n=================================");
    console.log("🎉 SAAS SEEDING COMPLETE");
    console.log("=================================");
    console.log("1. Super Admin (Global): super@saas.com / Super@123");
    console.log("2. Admin Toko (Demo):    admin@koperasi.com / Admin@123");
    console.log("3. Kasir Toko (Demo):    kasir@koperasi.com / Kasir@123");
    console.log("=================================\n");

    process.exit(0);
  } catch (error) {
    console.error("❌ Error seeding:", error);
    process.exit(1);
  }
};

createSaaSData();
