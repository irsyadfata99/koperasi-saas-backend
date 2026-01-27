// ============================================
// src/controllers/CategoryController.js (SAAS READY 🚀)
// ✅ FIXED: Inject clientId to creation
// ✅ FIXED: Data Isolation (Filter by clientId)
// ============================================
const Category = require("../models/Category");
const ApiResponse = require("../utils/response");
const { Op } = require("sequelize");

class CategoryController {
  // GET /api/categories - Get all categories with pagination & search
  static async getAll(req, res, next) {
    try {
      const {
        page = 1,
        limit = 20,
        search = "",
        isActive,
        sortBy = "createdAt",
        sortOrder = "DESC",
      } = req.query;

      const clientId = req.user.clientId; // ⬅️ AMBIL CLIENT ID

      const offset = (parseInt(page) - 1) * parseInt(limit);

      // Build where clause (Wajib filter clientId)
      const whereClause = { clientId };

      if (search) {
        whereClause.name = {
          [Op.like]: `%${search}%`,
        };
      }

      if (isActive !== undefined) {
        whereClause.isActive = isActive === "true";
      }

      // Get categories with pagination
      const { count, rows } = await Category.findAndCountAll({
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

      return ApiResponse.paginated(
        res,
        rows,
        pagination,
        "Kategori berhasil diambil"
      );
    } catch (error) {
      next(error);
    }
  }

  // GET /api/categories/:id - Get category by ID
  static async getById(req, res, next) {
    try {
      const { id } = req.params;
      const clientId = req.user.clientId; // ⬅️ Isolation check

      const category = await Category.findOne({
        where: { id, clientId }, // ✅ Cuma bisa lihat punya sendiri
      });

      if (!category) {
        return ApiResponse.error(res, "Kategori tidak ditemukan", 404);
      }

      return ApiResponse.success(res, category, "Kategori berhasil diambil");
    } catch (error) {
      next(error);
    }
  }

  // POST /api/categories - Create new category
  static async create(req, res, next) {
    try {
      const { name, description } = req.body;
      const clientId = req.user.clientId; // ⬅️ WAJIB ADA

      // Validation
      if (!name) {
        return ApiResponse.error(res, "Nama kategori harus diisi", 422);
      } else if (name.length < 3) {
        return ApiResponse.error(res, "Nama kategori minimal 3 karakter", 422);
      } else if (name.length > 50) {
        return ApiResponse.error(res, "Nama kategori maksimal 50 karakter", 422);
      }

      if (description && description.length > 255) {
        return ApiResponse.error(res, "Deskripsi maksimal 255 karakter", 422);
      }

      // Check if name exists (Hanya di toko sendiri)
      const existingCategory = await Category.findOne({
        where: { name, clientId }, // ✅ Cek duplikat per toko
      });

      if (existingCategory) {
        return ApiResponse.error(res, "Nama kategori sudah digunakan", 422);
      }

      // Create category with clientId
      const category = await Category.create({
        clientId, // ✅ INJECT CLIENT ID (Solusi Error notNull)
        name,
        description,
        isActive: true,
      });

      return ApiResponse.success(
        res,
        category,
        "Kategori berhasil dibuat",
        201
      );
    } catch (error) {
      next(error);
    }
  }

  // PUT /api/categories/:id - Update category
  static async update(req, res, next) {
    try {
      const { id } = req.params;
      const { name, description, isActive } = req.body;
      const clientId = req.user.clientId;

      // Cari kategori milik client ini
      const category = await Category.findOne({
        where: { id, clientId },
      });

      if (!category) {
        return ApiResponse.error(res, "Kategori tidak ditemukan", 404);
      }

      // Check duplicate name (exclude current category, scope per client)
      if (name && name !== category.name) {
        const existingCategory = await Category.findOne({
          where: {
            name,
            clientId, // ✅ Scope per toko
            id: { [Op.ne]: id },
          },
        });

        if (existingCategory) {
          return ApiResponse.error(res, "Nama kategori sudah digunakan", 422);
        }
      }

      // Update category
      await category.update({
        ...(name && { name }),
        description:
          description !== undefined ? description : category.description,
        ...(isActive !== undefined && { isActive }),
      });

      return ApiResponse.success(res, category, "Kategori berhasil diupdate");
    } catch (error) {
      next(error);
    }
  }

  // DELETE /api/categories/:id - Delete category (soft delete)
  static async delete(req, res, next) {
    try {
      const { id } = req.params;
      const clientId = req.user.clientId;

      const category = await Category.findOne({
        where: { id, clientId },
      });

      if (!category) {
        return ApiResponse.error(res, "Kategori tidak ditemukan", 404);
      }

      // Soft delete - just set isActive to false
      await category.update({ isActive: false });

      return ApiResponse.success(
        res,
        { id: category.id },
        "Kategori berhasil dihapus"
      );
    } catch (error) {
      next(error);
    }
  }

  // PATCH /api/categories/:id/toggle - Toggle active status
  static async toggleActive(req, res, next) {
    try {
      const { id } = req.params;
      const clientId = req.user.clientId;

      const category = await Category.findOne({
        where: { id, clientId },
      });

      if (!category) {
        return ApiResponse.error(res, "Kategori tidak ditemukan", 404);
      }

      await category.update({ isActive: !category.isActive });

      return ApiResponse.success(
        res,
        category,
        `Kategori berhasil ${category.isActive ? "diaktifkan" : "dinonaktifkan"}`
      );
    } catch (error) {
      next(error);
    }
  }
}

module.exports = CategoryController;