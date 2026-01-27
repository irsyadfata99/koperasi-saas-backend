// ============================================
// src/controllers/MemberController.js
// Controller untuk mengelola anggota (members)
// ✅ FIXED: Use REGIONS constant + max length validation
// ============================================
const Member = require("../models/Member");
const ApiResponse = require("../utils/response");
const { Op } = require("sequelize");
const { REGIONS, isValidRegionCode, getRegionName } = require("../constants/regions");

class MemberController {
  // ============================================
  // POST /api/members/register - Register new member (PUBLIC)
  // ============================================
  static async register(req, res, next) {
    try {
      const { nik, fullName, address, regionCode, whatsapp, gender, clientId } = req.body; // ✅ clientId required from body

      // ===== VALIDATION =====
      const errors = {};

      if (!clientId) {
        errors.clientId = ["Client ID harus diisi"];
      }

      // NIK validation
      if (!nik) {
        errors.nik = ["NIK harus diisi"];
      } else if (nik.length !== 16) {
        errors.nik = ["NIK harus 16 digit"];
      } else if (!/^\d+$/.test(nik)) {
        errors.nik = ["NIK hanya boleh berisi angka"];
      }

      // Full Name validation
      if (!fullName) {
        errors.fullName = ["Nama lengkap harus diisi"];
      } else if (fullName.length < 3) {
        errors.fullName = ["Nama lengkap minimal 3 karakter"];
      } else if (fullName.length > 100) {
        errors.fullName = ["Nama lengkap maksimal 100 karakter"];
      }

      // Address validation
      if (!address) {
        errors.address = ["Alamat harus diisi"];
      } else if (address.length < 10) {
        errors.address = ["Alamat minimal 10 karakter"];
      } else if (address.length > 255) {
        errors.address = ["Alamat maksimal 255 karakter"];
      }

      // Region Code validation (use constant)
      if (!regionCode) {
        errors.regionCode = ["Wilayah harus dipilih"];
      } else if (!isValidRegionCode(regionCode)) {
        errors.regionCode = ["Kode wilayah tidak valid"];
      }

      // WhatsApp validation (max 15 chars)
      if (!whatsapp) {
        errors.whatsapp = ["Nomor WhatsApp harus diisi"];
      } else if (whatsapp.length > 15) {
        errors.whatsapp = ["Nomor WhatsApp maksimal 15 karakter"];
      } else if (!/^08\d{8,11}$/.test(whatsapp)) {
        errors.whatsapp = ["Format nomor WhatsApp tidak valid (contoh: 081234567890)"];
      }

      // Gender validation
      if (!gender) {
        errors.gender = ["Jenis kelamin harus dipilih"];
      } else if (!["Laki-laki", "Perempuan"].includes(gender)) {
        errors.gender = ["Jenis kelamin harus Laki-laki atau Perempuan"];
      }

      // If there are validation errors, return early
      if (Object.keys(errors).length > 0) {
        return ApiResponse.validationError(res, errors, "Data tidak valid");
      }

      // ===== CHECK NIK EXISTS =====
      const existingNik = await Member.findOne({ where: { nik } });
      if (existingNik) {
        return ApiResponse.error(res, "NIK sudah terdaftar", 422, {
          nik: ["NIK sudah terdaftar"],
        });
      }

      // ===== GENERATE UNIQUE ID =====
      const uniqueId = await Member.generateUniqueId(regionCode, clientId); // ✅ Pass clientId

      // ===== GET REGION NAME (from constant) =====
      const regionName = getRegionName(regionCode);

      // ===== CREATE MEMBER =====
      const member = await Member.create({
        clientId, // ✅ Add clientId
        uniqueId,
        nik,
        fullName,
        address,
        regionCode,
        regionName,
        whatsapp,
        gender,
        totalDebt: 0,
        totalTransactions: 0,
        monthlySpending: 0,
        totalPoints: 0,
        isActive: true,
      });

      // ===== LOG ACTIVITY =====
      console.log(`✅ Member registered: ${member.uniqueId} - ${member.fullName}`);

      return ApiResponse.created(res, member, "Pendaftaran anggota berhasil");
    } catch (error) {
      console.error("❌ Error registering member:", error);
      next(error);
    }
  }

  // ============================================
  // GET /api/members/search/:uniqueId - Search member by uniqueId (PUBLIC)
  // ============================================
  static async searchByUniqueId(req, res, next) {
    try {
      const { uniqueId } = req.params;
      const { clientId } = req.query; // ✅ Must be passed for public search to resolve ambiguity

      // Validation
      if (!uniqueId) {
        return ApiResponse.error(res, "Unique ID harus diisi", 422);
      }
      if (!clientId) {
        return ApiResponse.error(res, "Client ID harus disertakan (Query Param)", 422);
      }

      // Normalize uniqueId (trim and uppercase)
      const normalizedId = uniqueId.trim().toUpperCase();

      console.log(`🔍 Searching for member: ${normalizedId} (Client: ${clientId})`);

      // Search member
      const member = await Member.findOne({
        where: {
          clientId, // ✅ Isolation
          uniqueId: {
            [Op.like]: normalizedId,
          },
        },
        raw: false,
      });

      // Log hasil pencarian
      if (member) {
        console.log(`✅ Member found in DB:`, {
          uniqueId: member.uniqueId,
          fullName: member.fullName,
          isActive: member.isActive,
        });
      } else {
        console.log(`❌ Member not found for: ${normalizedId}`);

        // Debug: Cari semua member dengan prefix yang sama
        const prefix = normalizedId.split("-")[0];
        const similarMembers = await Member.findAll({
          where: {
            uniqueId: {
              [Op.like]: `${prefix}%`,
            },
          },
          attributes: ["uniqueId", "fullName"],
          limit: 5,
        });

        console.log(`📋 Similar members with prefix ${prefix}:`, similarMembers.map((m) => m.uniqueId).join(", "));
      }

      if (!member) {
        return ApiResponse.notFound(res, "Anggota tidak ditemukan");
      }

      // Check if member is active
      if (!member.isActive) {
        console.log(`⚠️ Member ${member.uniqueId} is inactive`);
        return ApiResponse.error(res, "Anggota tidak aktif", 403);
      }

      console.log(`✅ Returning member data: ${member.uniqueId} - ${member.fullName}`);

      return ApiResponse.success(res, member, "Anggota ditemukan");
    } catch (error) {
      console.error("❌ Error searching member:", error);
      next(error);
    }
  }

  // ============================================
  // GET /api/members - Get all members with pagination (ADMIN/KASIR)
  // ============================================
  static async getAll(req, res, next) {
    try {
      const { page = 1, limit = 10, search = "", regionCode = "", isActive, sortBy = "createdAt", sortOrder = "DESC" } = req.query;
      const clientId = req.user.clientId; // ✅ Isolation

      const offset = (parseInt(page) - 1) * parseInt(limit);

      // Build where clause
      const whereClause = { clientId };

      // Search by name, uniqueId, or NIK
      if (search) {
        whereClause[Op.or] = [{ fullName: { [Op.like]: `%${search}%` } }, { uniqueId: { [Op.like]: `%${search}%` } }, { nik: { [Op.like]: `%${search}%` } }];
      }

      // Filter by region
      if (regionCode) {
        whereClause.regionCode = regionCode;
      }

      // Filter by active status
      if (isActive !== undefined) {
        whereClause.isActive = isActive === "true";
      }

      // Get members with pagination
      const { count, rows } = await Member.findAndCountAll({
        where: whereClause,
        limit: parseInt(limit),
        offset: offset,
        order: [[sortBy, sortOrder.toUpperCase()]],
      });

      const pagination = {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / parseInt(limit)),
      };

      return ApiResponse.paginated(res, rows, pagination, "Data anggota berhasil diambil");
    } catch (error) {
      console.error("❌ Error getting members:", error);
      next(error);
    }
  }

  // ============================================
  // GET /api/members/:id - Get member by ID (ADMIN/KASIR)
  // ============================================
  static async getById(req, res, next) {
    try {
      const { id } = req.params;
      const clientId = req.user.clientId; // ✅ Isolation

      const member = await Member.findOne({ where: { id, clientId } });

      if (!member) {
        return ApiResponse.notFound(res, "Anggota tidak ditemukan");
      }

      return ApiResponse.success(res, member, "Data anggota berhasil diambil");
    } catch (error) {
      console.error("❌ Error getting member by ID:", error);
      next(error);
    }
  }

  // ============================================
  // PUT /api/members/:id - Update member (ADMIN)
  // ============================================
  static async update(req, res, next) {
    try {
      const { id } = req.params;
      const { fullName, address, regionCode, whatsapp, gender, isActive } = req.body;

      const member = await Member.findByPk(id);

      if (!member) {
        return ApiResponse.notFound(res, "Anggota tidak ditemukan");
      }

      // Validation
      const errors = {};

      if (fullName) {
        if (fullName.length < 3) {
          errors.fullName = ["Nama lengkap minimal 3 karakter"];
        } else if (fullName.length > 100) {
          errors.fullName = ["Nama lengkap maksimal 100 karakter"];
        }
      }

      if (address) {
        if (address.length < 10) {
          errors.address = ["Alamat minimal 10 karakter"];
        } else if (address.length > 255) {
          errors.address = ["Alamat maksimal 255 karakter"];
        }
      }

      if (regionCode && !isValidRegionCode(regionCode)) {
        errors.regionCode = ["Kode wilayah tidak valid"];
      }

      if (whatsapp) {
        if (whatsapp.length > 15) {
          errors.whatsapp = ["Nomor WhatsApp maksimal 15 karakter"];
        } else if (!/^08\d{8,11}$/.test(whatsapp)) {
          errors.whatsapp = ["Format nomor WhatsApp tidak valid"];
        }
      }

      if (gender && !["Laki-laki", "Perempuan"].includes(gender)) {
        errors.gender = ["Jenis kelamin tidak valid"];
      }

      if (Object.keys(errors).length > 0) {
        return ApiResponse.validationError(res, errors, "Data tidak valid");
      }

      // Update member
      const updateData = {};
      if (fullName) updateData.fullName = fullName;
      if (address) updateData.address = address;
      if (whatsapp) updateData.whatsapp = whatsapp;
      if (gender) updateData.gender = gender;
      if (isActive !== undefined) updateData.isActive = isActive;

      // If region changed, update regionName and regenerate uniqueId
      if (regionCode && regionCode !== member.regionCode) {
        const newUniqueId = await Member.generateUniqueId(regionCode);
        updateData.regionCode = regionCode;
        updateData.regionName = getRegionName(regionCode);
        updateData.uniqueId = newUniqueId;
      }

      await member.update(updateData);

      console.log(`✅ Member updated: ${member.uniqueId} - ${member.fullName}`);

      return ApiResponse.success(res, member, "Data anggota berhasil diupdate");
    } catch (error) {
      console.error("❌ Error updating member:", error);
      next(error);
    }
  }

  // ============================================
  // DELETE /api/members/:id - Soft delete member (ADMIN)
  // ============================================
  static async delete(req, res, next) {
    try {
      const { id } = req.params;

      const member = await Member.findByPk(id);

      if (!member) {
        return ApiResponse.notFound(res, "Anggota tidak ditemukan");
      }

      // Soft delete - set isActive to false
      await member.update({ isActive: false });

      console.log(`🗑️ Member deactivated: ${member.uniqueId} - ${member.fullName}`);

      return ApiResponse.success(res, { id: member.id }, "Anggota berhasil dinonaktifkan");
    } catch (error) {
      console.error("❌ Error deleting member:", error);
      next(error);
    }
  }

  // ============================================
  // PATCH /api/members/:id/toggle - Toggle member active status (ADMIN)
  // ============================================
  static async toggleActive(req, res, next) {
    try {
      const { id } = req.params;

      const member = await Member.findByPk(id);

      if (!member) {
        return ApiResponse.notFound(res, "Anggota tidak ditemukan");
      }

      await member.update({ isActive: !member.isActive });

      console.log(`🔄 Member ${member.isActive ? "activated" : "deactivated"}: ${member.uniqueId} - ${member.fullName}`);

      return ApiResponse.success(res, member, `Anggota berhasil ${member.isActive ? "diaktifkan" : "dinonaktifkan"}`);
    } catch (error) {
      console.error("❌ Error toggling member status:", error);
      next(error);
    }
  }

  // ============================================
  // GET /api/members/stats - Get member statistics (ADMIN/KASIR)
  // ============================================
  static async getStats(req, res, next) {
    try {
      const clientId = req.user.clientId;
      const totalMembers = await Member.count({ where: { clientId } });
      const activeMembers = await Member.count({ where: { clientId, isActive: true } });
      const inactiveMembers = await Member.count({
        where: { clientId, isActive: false },
      });

      const stats = {
        totalMembers,
        activeMembers,
        inactiveMembers,
      };

      return ApiResponse.success(res, stats, "Statistik anggota berhasil diambil");
    } catch (error) {
      console.error("❌ Error getting member stats:", error);
      next(error);
    }
  }
}

module.exports = MemberController;
