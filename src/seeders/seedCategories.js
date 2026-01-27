// ============================================
// src/seeders/seedCategories.js
// Seeder untuk membuat kategori produk
// ============================================
const { sequelize } = require("../config/database");
const Category = require("../models/Category");
const Client = require("../models/Client");
require("dotenv").config();

const categoryData = [
  {
    name: "Sembako",
    description: "Bahan makanan pokok (beras, minyak, gula, tepung, dll)",
  },
  {
    name: "Minuman",
    description: "Air mineral, teh, kopi, soft drink, jus, dll",
  },
  {
    name: "Snack",
    description: "Makanan ringan, keripik, biskuit, coklat, permen, dll",
  },
  {
    name: "Mie Instan",
    description: "Mie instan berbagai merek dan rasa",
  },
  {
    name: "Susu",
    description: "Susu cair, susu bubuk, susu kental manis, dll",
  },
  {
    name: "Toiletries",
    description: "Sabun, shampoo, pasta gigi, detergen, dan kebutuhan mandi",
  },
  {
    name: "Bumbu Dapur",
    description: "Bumbu masak, kecap, saus, MSG, garam, merica, dll",
  },
  {
    name: "Frozen Food",
    description: "Makanan beku (nugget, sosis, bakso, dll)",
  },
  {
    name: "Roti & Kue",
    description: "Roti tawar, roti manis, kue kering, dll",
  },
  {
    name: "Kebutuhan Bayi",
    description: "Popok, susu bayi, bedak bayi, dll",
  },
  {
    name: "Alat Tulis",
    description: "Pulpen, pensil, buku tulis, kertas, dll",
  },
  {
    name: "Rokok",
    description: "Berbagai merek rokok",
  },
  {
    name: "Elektronik",
    description: "Baterai, lampu, kabel, dan elektronik kecil lainnya",
  },
  {
    name: "Lain-lain",
    description: "Produk lain yang tidak termasuk kategori di atas",
  },
];

const seedCategories = async () => {
  try {
    console.log("🌱 Starting category seeding...");
    await sequelize.authenticate();

    // 1. CARI CLIENT TARGET
    // Kita akan insert kategori ini untuk "Koperasi Demo" yang dibuat di step sebelumnya
    const client = await Client.findOne({ where: { code: "DEMO-01" } });

    if (!client) {
      throw new Error(
        "❌ Client 'DEMO-01' not found. Run createAdminUser.js first!",
      );
    }

    console.log(`Target Client: ${client.businessName} (${client.id})\n`);

    let successCount = 0;

    for (const data of categoryData) {
      // 2. CEK DUPLIKAT PER CLIENT
      const existing = await Category.findOne({
        where: {
          clientId: client.id, // ✅ Filter by Client
          name: data.name,
        },
      });

      if (!existing) {
        await Category.create({
          clientId: client.id, // ✅ Wajib isi ini
          name: data.name,
          description: data.description,
          isActive: true,
        });
        successCount++;
        console.log(`✅ Created: ${data.name}`);
      } else {
        console.log(`⏭️  Skipped: ${data.name}`);
      }
    }

    console.log(
      `\n🎉 Finished! Added ${successCount} categories for ${client.businessName}`,
    );
    process.exit(0);
  } catch (error) {
    console.error("\n❌ Error:", error);
    process.exit(1);
  }
};
// Run seeder
seedCategories();
