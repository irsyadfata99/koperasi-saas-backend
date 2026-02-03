// ============================================
// src/controllers/AuthController.js (SAAS READY)
// ============================================
const User = require("../models/User");
const Client = require("../models/Client"); // ✅ Import Client Model
const ApiResponse = require("../utils/response");
const jwt = require("jsonwebtoken");
const { Op } = require("sequelize");

class AuthController {
  // POST /api/auth/register
  // Digunakan oleh Admin Toko untuk mendaftarkan Kasir/Staff baru
  static async register(req, res, next) {
    try {
      // Pastikan yang akses sudah login (lewat middleware authenticate)
      const currentUser = req.user;

      // Validasi: Hanya Admin Toko atau Super Admin yang boleh create user
      if (
        !currentUser ||
        (currentUser.role !== "ADMIN" && currentUser.role !== "SUPER_ADMIN")
      ) {
        return ApiResponse.error(
          res,
          "Anda tidak memiliki akses untuk mendaftarkan user",
          403,
        );
      }

      const { username, email, name, password, role } = req.body;

      // Validation Basic
      if (!username || !email || !name || !password) {
        return ApiResponse.error(res, "Semua field harus diisi", 422);
      }

      // 1. Tentukan Client ID untuk user baru
      // Jika Super Admin yg buat, dia harus kirim clientId di body.
      // Jika Admin Toko yg buat, otomatis pakai clientId dia.
      let targetClientId = currentUser.clientId;

      if (currentUser.role === "SUPER_ADMIN") {
        if (!req.body.clientId)
          return ApiResponse.error(
            res,
            "Super Admin wajib menyertakan clientId",
            422,
          );
        targetClientId = req.body.clientId;
      }

      // 2. Cek Username Unik (Per Client)
      // User 'kasir' di Toko A boleh ada, walaupun di Toko B juga ada 'kasir'
      const existingUsername = await User.findOne({
        where: {
          username: username,
          clientId: targetClientId,
        },
      });

      if (existingUsername) {
        return ApiResponse.error(
          res,
          "Username sudah digunakan di toko ini",
          422,
        );
      }

      // 3. Cek Email Unik (Global)
      // Email tetap harus unik global untuk memudahkan login/reset password
      const existingEmail = await User.findOne({ where: { email } });
      if (existingEmail) {
        return ApiResponse.error(res, "Email sudah terdaftar di sistem", 422);
      }

      // 4. Create User
      const user = await User.create({
        clientId: targetClientId, // ✅ Assign ke Toko
        username,
        email,
        name,
        password, // Hash otomatis di User hooks
        role: role || "KASIR",
        isActive: true,
      });

      return ApiResponse.success(
        res,
        {
          id: user.id,
          username: user.username,
          role: user.role,
          clientId: user.clientId,
        },
        "User berhasil didaftarkan",
        201,
      );
    } catch (error) {
      next(error);
    }
  }

  // POST /api/auth/login - Login user (Support SaaS)
  static async login(req, res, next) {
    try {
      console.log("🔐 Login attempt:", req.body.username || req.body.email);

      const { username, password } = req.body; // username bisa diisi email juga

      if (!username || !password) {
        return ApiResponse.error(
          res,
          "Username/Email dan password harus diisi",
          422,
        );
      }

      // 1. Cari User (Support Login via Email atau Username)
      // Kita include Client untuk cek status langganan
      const user = await User.findOne({
        where: {
          [Op.or]: [
            { email: username }, // Cek email
            { username: username }, // Cek username
          ],
        },
        include: [
          {
            model: Client,
            as: "client",
            required: false, // False karena Super Admin tidak punya client
          },
        ],
      });

      if (!user) {
        return ApiResponse.error(
          res,
          "Akun tidak ditemukan atau password salah",
          401,
        );
      }

      // 2. Validasi Password
      const isPasswordValid = await user.comparePassword(password);
      if (!isPasswordValid) {
        return ApiResponse.error(
          res,
          "Akun tidak ditemukan atau password salah",
          401,
        );
      }

      // 3. Cek Status User & Client
      if (!user.isActive) {
        return ApiResponse.error(res, "Akun Anda dinonaktifkan", 403);
      }

      if (user.role !== "SUPER_ADMIN") {
        // Jika bukan Super Admin, wajib punya Client
        if (!user.client) {
          return ApiResponse.error(
            res,
            "Data Client korup (Hubungi Support)",
            500,
          );
        }
        // SAAS CHECK: Apakah toko aktif?
        if (user.client.status !== "ACTIVE") {
          return ApiResponse.error(
            res,
            `Akses ditolak. Status Toko: ${user.client.status}`,
            403,
          );
        }
      }

      // 4. Generate Token (SaaS Payload)
      const tokenPayload = {
        userId: user.id,
        role: user.role,
        clientId: user.clientId, // ✅ PENTING: ID Toko masuk ke token
      };

      const token = jwt.sign(tokenPayload, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES_IN || "1d",
      });

      // 5. Tentukan Redirect Strategy (Untuk Frontend)
      let redirectTarget = "/dashboard"; // Default
      let appScope = "POS"; // POS atau ADMIN_PANEL

      if (user.role === "SUPER_ADMIN") {
        redirectTarget = "/admin/dashboard"; // Dashboard Khusus Kamu
        appScope = "ADMIN_PANEL";
      } else if (user.role === "ADMIN") {
        redirectTarget = "/store/dashboard"; // Dashboard Admin Toko
        appScope = "POS";
      } else {
        redirectTarget = "/pos/transaction"; // Langsung ke mesin kasir
        appScope = "POS";
      }

      return ApiResponse.success(
        res,
        {
          token,
          user: {
            id: user.id,
            clientId: user.clientId, // ✅ ADDED: Include clientId for frontend
            name: user.name,
            email: user.email,
            role: user.role,
            username: user.username,
            // Info Client untuk ditampilkan di Header Frontend
            clientName: user.client
              ? user.client.businessName
              : "Super Admin System",
          },
          meta: {
            redirectTarget, // Frontend baca ini untuk redirect
            appScope, // Frontend baca ini untuk tahu mode aplikasi
          },
        },
        "Login berhasil",
      );
    } catch (error) {
      console.error("❌ Login error:", error);
      next(error);
    }
  }

  // GET /api/auth/me - Get current user info
  static async me(req, res, next) {
    try {
      // req.user sudah di-inject oleh middleware 'auth.js'
      // Tapi kita fetch ulang biar dapat data Client terbaru
      const user = await User.findByPk(req.user.id, {
        attributes: { exclude: ["password"] },
        include: [
          {
            model: Client,
            as: "client",
            attributes: ["businessName", "address", "phone", "status"],
          },
        ],
      });

      if (!user) return ApiResponse.error(res, "User tidak ditemukan", 404);

      return ApiResponse.success(res, user, "User info berhasil diambil");
    } catch (error) {
      next(error);
    }
  }

  // Change Password tetap sama, logic-nya standar
  static async changePassword(req, res, next) {
    try {
      const { oldPassword, newPassword } = req.body;
      const user = await User.findByPk(req.user.id);

      if (!oldPassword || !newPassword) {
        return ApiResponse.error(
          res,
          "Password lama dan baru harus diisi",
          422,
        );
      }

      if (newPassword.length < 8) {
        // Update ke 8 sesuai validasi model baru
        return ApiResponse.error(res, "Password baru minimal 8 karakter", 422);
      }

      const isOldPasswordValid = await user.comparePassword(oldPassword);
      if (!isOldPasswordValid) {
        return ApiResponse.error(res, "Password lama salah", 401);
      }

      // Update via method instance (biar hook beforeUpdate jalan hash passwordnya)
      user.password = newPassword;
      user.lastPasswordChange = new Date();
      await user.save();

      return ApiResponse.success(res, null, "Password berhasil diubah");
    } catch (error) {
      next(error);
    }
  }
}

module.exports = AuthController;
