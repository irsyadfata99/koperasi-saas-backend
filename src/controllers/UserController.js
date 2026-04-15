// src/controllers/UserController.js
const { Op } = require("sequelize");
const User = require("../models/User");
const Client = require("../models/Client");
const ApiResponse = require("../utils/response");

class UserController {
    // ============================================
    // GET /api/users - Get all users
    // Access: SUPER_ADMIN (all users), ADMIN (own client users)
    // ============================================
    static async getAll(req, res, next) {
        try {
            const {
                page = 1,
                limit = 10,
                search = "",
                role,
                status,
                sortBy = "createdAt",
                sortOrder = "DESC",
            } = req.query;

            const currentUser = req.user;
            const pageNum = Math.max(1, parseInt(page) || 1);
            const limitNum = Math.min(100, Math.max(1, parseInt(limit) || 10));
            const offset = (pageNum - 1) * limitNum;

            const whereClause = {};

            // Role-based Access Control
            if (currentUser.role === "SUPER_ADMIN") {
                // Can see all users, optional filter by clientId if passed in query
                if (req.query.clientId) {
                    whereClause.clientId = req.query.clientId;
                }
            } else if (currentUser.role === "ADMIN") {
                // Only see users in own client
                whereClause.clientId = currentUser.clientId;
            } else {
                return ApiResponse.error(res, "Unauthorized", 403);
            }

            // Search Logic
            if (search) {
                whereClause[Op.or] = [
                    { name: { [Op.like]: `%${search}%` } },
                    { username: { [Op.like]: `%${search}%` } },
                    { email: { [Op.like]: `%${search}%` } },
                ];
            }

            if (role) whereClause.role = role;
            if (status) {
                if (status.toUpperCase() === "ACTIVE") whereClause.isActive = true;
                if (status.toUpperCase() === "INACTIVE") whereClause.isActive = false;
            }

            const { count, rows } = await User.findAndCountAll({
                where: whereClause,
                limit: limitNum,
                offset: offset,
                attributes: { exclude: ["password"] },
                include: [
                    {
                        model: Client,
                        as: "client",
                        attributes: ["id", "businessName", "code"],
                        required: false,
                    },
                ],
                order: [[sortBy, sortOrder.toUpperCase() === "ASC" ? "ASC" : "DESC"]],
            });

            const pagination = {
                page: pageNum,
                limit: limitNum,
                total: count,
                totalPages: Math.ceil(count / limitNum),
            };

            return ApiResponse.paginated(res, rows, pagination, "Data user berhasil diambil");
        } catch (error) {
            next(error);
        }
    }

    // ============================================
    // POST /api/users - Create new user
    // Access: SUPER_ADMIN only
    // ============================================
    static async create(req, res, next) {
        try {
            const { name, username, email, password, role, clientId, isActive = true } = req.body;
            const currentUser = req.user;

            // Authorization Logic
            let finalClientId = clientId;
            
            if (currentUser.role !== "SUPER_ADMIN") {
                if (currentUser.role !== "ADMIN") {
                    return ApiResponse.error(res, "Unauthorized - Hanya SUPER_ADMIN atau ADMIN yang dapat membuat user", 403);
                }
                
                // ADMIN can only create KASIR or STAFF, and only for their own clientId
                if (role === "SUPER_ADMIN" || role === "ADMIN") {
                    return ApiResponse.error(res, "Unauthorized - ADMIN tidak dapat membuat user dengan role ini", 403);
                }
                finalClientId = currentUser.clientId;
            }

            // Validation
            if (!username || !password || !role || !finalClientId) {
                return ApiResponse.validationError(res, {
                    general: ["Username, password, role, and clientId are required"]
                }, "Validation failed");
            }

            // Check client exists
            const client = await Client.findByPk(finalClientId);
            if (!client) {
                return ApiResponse.notFound(res, "Client tidak ditemukan");
            }

            // Check username uniqueness
            const existingUsername = await User.findOne({ where: { username } });
            if (existingUsername) {
                return ApiResponse.validationError(res, { username: ["Username sudah digunakan"] }, "Username duplicate");
            }

            // Check email uniqueness if provided
            if (email) {
                const existingEmail = await User.findOne({ where: { email } });
                if (existingEmail) {
                    return ApiResponse.validationError(res, { email: ["Email sudah digunakan"] }, "Email duplicate");
                }
            }

            // Create user
            const user = await User.create({
                name: name || username,
                username,
                email: email || null,
                password, // Model hook will hash
                role,
                clientId: finalClientId,
                isActive
            });

            return ApiResponse.success(res, {
                id: user.id,
                name: user.name,
                username: user.username,
                role: user.role,
                clientId: user.clientId
            }, "User berhasil dibuat", 201);
        } catch (error) {
            next(error);
        }
    }

    // ============================================
    // GET /api/users/:id - Get user by ID
    // ============================================
    static async getById(req, res, next) {
        try {
            const { id } = req.params;
            const currentUser = req.user;

            const user = await User.findByPk(id, {
                attributes: { exclude: ["password"] },
                include: [
                    {
                        model: Client,
                        as: "client",
                        attributes: ["id", "businessName", "code"],
                        required: false,
                    },
                ],
            });

            if (!user) return ApiResponse.notFound(res, "User tidak ditemukan");

            // Authorization Check
            if (currentUser.role !== "SUPER_ADMIN") {
                if (user.clientId !== currentUser.clientId) {
                    return ApiResponse.error(res, "Unauthorized", 403);
                }
            }

            return ApiResponse.success(res, user, "Detail user berhasil diambil");
        } catch (error) {
            next(error);
        }
    }

    // ============================================
    // PUT /api/users/:id - Update user
    // ============================================
    static async update(req, res, next) {
        try {
            const { id } = req.params;
            const { name, email, role, isActive, password } = req.body;
            const currentUser = req.user;

            const user = await User.findByPk(id);
            if (!user) return ApiResponse.notFound(res, "User tidak ditemukan");

            // Authorization Check
            if (currentUser.role !== "SUPER_ADMIN") {
                if (user.clientId !== currentUser.clientId) {
                    return ApiResponse.error(res, "Unauthorized", 403);
                }
                // ADMIN cannot change user to SUPER_ADMIN
                if (role === "SUPER_ADMIN") {
                    return ApiResponse.error(res, "Tidak dapat mengubah role ke SUPER_ADMIN", 403);
                }
            }

            // Validasi Email Unik jika berubah
            if (email && email !== user.email) {
                const existingEmail = await User.findOne({ where: { email, id: { [Op.ne]: id } } });
                if (existingEmail) return ApiResponse.validationError(res, { email: ["Email sudah digunakan"] }, "Email duplicate");
            }

            // Update fields
            if (name) user.name = name;
            if (email !== undefined) user.email = email || null;
            if (role) user.role = role;
            if (isActive !== undefined) user.isActive = isActive;

            // Update password if provided (Controller handles hashing usually or model hook)
            // Model user has beforeUpdate hook, so we just set it.
            if (password) {
                // Validate strength check if needed, already in model hooks/validation? 
                // Better to use User.validatePasswordStrength if available or rely on validation error from save
                user.password = password;
            }

            await user.save();

            return ApiResponse.success(res, { id: user.id, name: user.name, role: user.role }, "User berhasil diupdate");
        } catch (error) {
            next(error);
        }
    }

    // ============================================
    // DELETE /api/users/:id - Delete (Soft/Hard)
    // ============================================
    static async delete(req, res, next) {
        try {
            const { id } = req.params;
            const currentUser = req.user;

            const user = await User.findByPk(id);
            if (!user) return ApiResponse.notFound(res, "User tidak ditemukan");

            // Authorization
            if (currentUser.role !== "SUPER_ADMIN") {
                if (user.clientId !== currentUser.clientId) {
                    return ApiResponse.error(res, "Unauthorized", 403);
                }
            }

            // Prevent deleting self
            if (user.id === currentUser.id) {
                return ApiResponse.error(res, "Tidak dapat menghapus diri sendiri", 400);
            }

            await user.destroy();
            return ApiResponse.success(res, null, "User berhasil dihapus");
        } catch (error) {
            // Handle foreign key constraint error
            if (error.name === 'SequelizeForeignKeyConstraintError') {
                return ApiResponse.error(res, "Gagal menghapus user karena masih terhubung dengan data transaksi. Silakan set status menjadi INACTIVE saja.", 400);
            }
            next(error);
        }
    }

    // ============================================
    // POST /api/users/:id/reset-password - Reset password
    // ============================================
    static async resetPassword(req, res, next) {
        try {
            const { id } = req.params;
            const { password } = req.body;
            const currentUser = req.user;

            const user = await User.findByPk(id);
            if (!user) return ApiResponse.notFound(res, "User tidak ditemukan");

            // Authorization Check
            if (currentUser.role !== "SUPER_ADMIN") {
                if (user.clientId !== currentUser.clientId) {
                    return ApiResponse.error(res, "Unauthorized", 403);
                }
            }

            if (!password || password.length < 6) {
                return ApiResponse.validationError(res, { password: ["Password minimal 6 karakter"] }, "Data tidak valid");
            }

            user.password = password;
            await user.save();

            return ApiResponse.success(res, null, "Password berhasil di-reset");
        } catch (error) {
            next(error);
        }
    }

    // ============================================
    // PATCH /api/users/:id/status - Update user status
    // ============================================
    static async updateStatus(req, res, next) {
        try {
            const { id } = req.params;
            const { status } = req.body;
            const currentUser = req.user;

            const user = await User.findByPk(id);
            if (!user) return ApiResponse.notFound(res, "User tidak ditemukan");

            // Authorization Check
            if (currentUser.role !== "SUPER_ADMIN") {
                if (user.clientId !== currentUser.clientId) {
                    return ApiResponse.error(res, "Unauthorized", 403);
                }
            }

            if (user.id === currentUser.id) {
                return ApiResponse.error(res, "Tidak dapat merubah status diri sendiri", 400);
            }

            user.isActive = status === "ACTIVE";
            await user.save();

            return ApiResponse.success(res, null, "Status berhasil diupdate");
        } catch (error) {
            next(error);
        }
    }
}

module.exports = UserController;
