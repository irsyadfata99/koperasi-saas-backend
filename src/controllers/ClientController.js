// src/controllers/ClientController.js
const { Op } = require("sequelize");
const Client = require("../models/Client");
const User = require("../models/User"); // ✅ Import User
const Setting = require("../models/Setting"); // ✅ Import Setting for auto-init
const { sequelize } = require("../config/database"); // ✅ Import Sequelize for Transaction
const ApiResponse = require("../utils/response");

class ClientController {
    // ============================================
    // GET /api/clients - Get all clients
    //Payload: query params (page, limit, search, status)
    // ============================================
    static async getAll(req, res, next) {
        try {
            const {
                page = 1,
                limit = 10,
                search = "",
                status,
                sortBy = "createdAt",
                sortOrder = "DESC",
            } = req.query;

            const pageNum = Math.max(1, parseInt(page) || 1);
            const limitNum = Math.min(100, Math.max(1, parseInt(limit) || 10));
            const offset = (pageNum - 1) * limitNum;

            const whereClause = {};

            if (search) {
                whereClause[Op.or] = [
                    { businessName: { [Op.like]: `%${search}%` } },
                    { code: { [Op.like]: `%${search}%` } },
                    { ownerName: { [Op.like]: `%${search}%` } },
                ];
            }

            if (status && ["ACTIVE", "SUSPENDED", "INACTIVE"].includes(status.toUpperCase())) {
                whereClause.status = status.toUpperCase();
            }

            const { count, rows } = await Client.findAndCountAll({
                where: whereClause,
                limit: limitNum,
                offset: offset,
                order: [[sortBy, sortOrder.toUpperCase() === "ASC" ? "ASC" : "DESC"]],
            });

            const pagination = {
                page: pageNum,
                limit: limitNum,
                total: count,
                totalPages: Math.ceil(count / limitNum),
            };

            return ApiResponse.paginated(res, rows, pagination, "Data client berhasil diambil");
        } catch (error) {
            next(error);
        }
    }

    // ============================================
    // GET /api/clients/:id - Get client by ID
    // ============================================
    static async getById(req, res, next) {
        try {
            const { id } = req.params;
            const client = await Client.findByPk(id);

            if (!client) {
                return ApiResponse.notFound(res, "Client tidak ditemukan");
            }

            return ApiResponse.success(res, client, "Detail client berhasil diambil");
        } catch (error) {
            next(error);
        }
    }

    // ============================================
    // POST /api/clients - Create new client
    // ============================================
    static async create(req, res, next) {
        const t = await sequelize.transaction(); // ✅ Start Transaction

        try {
            const {
                code, // Now optional - will auto-generate if not provided
                businessName,
                ownerName,
                phone,
                address,
                subscriptionPlan,
                subscriptionEnd,
                // User Credentials for new Client
                adminUser, // { username, password, email, name }
                cashierUser // { username, password, email, name }
            } = req.body;

            // Basic Validation - only businessName is required now
            if (!businessName) {
                await t.rollback();
                return ApiResponse.validationError(
                    res,
                    {
                        businessName: ["Nama bisnis harus diisi"],
                    },
                    "Data tidak lengkap"
                );
            }

            // ✅ Auto-generate code if not provided (CLI-YEAR-XXXX format)
            let clientCode = code;
            if (!clientCode) {
                const year = new Date().getFullYear();
                const randomPart = Math.random().toString(36).substring(2, 6).toUpperCase();
                clientCode = `CLI-${year}-${randomPart}`;

                // Ensure uniqueness
                let attempts = 0;
                while (await Client.findOne({ where: { code: clientCode } }) && attempts < 10) {
                    const newRandom = Math.random().toString(36).substring(2, 6).toUpperCase();
                    clientCode = `CLI-${year}-${newRandom}`;
                    attempts++;
                }
            }

            // check required adminUser data
            if (!adminUser || !adminUser.username || !adminUser.password || !adminUser.email) {
                await t.rollback();
                return ApiResponse.error(res, "Data Admin (username, password, email) wajib diisi untuk setup awal", 422);
            }

            // Check duplicate code
            const existingCode = await Client.findOne({ where: { code: clientCode } });
            if (existingCode) {
                await t.rollback();
                return ApiResponse.validationError(
                    res,
                    { code: ["Kode client sudah digunakan"] },
                    "Kode client duplicate"
                );
            }

            // Check duplicate username/email globally for Admin
            const existingAdmin = await User.findOne({
                where: {
                    [Op.or]: [{ username: adminUser.username }, { email: adminUser.email }]
                }
            });
            if (existingAdmin) {
                await t.rollback();
                return ApiResponse.error(res, "Username/Email Admin sudah digunakan di sistem", 409);
            }

            // 1. Create Client
            const client = await Client.create({
                code: clientCode,
                businessName,
                ownerName,
                phone,
                address,
                subscriptionPlan: subscriptionPlan || "FREE",
                subscriptionEnd: subscriptionEnd || null,
                status: "ACTIVE",
            }, { transaction: t });

            // 2. Create Admin User
            await User.create({
                clientId: client.id,
                username: adminUser.username,
                email: adminUser.email,
                name: adminUser.name || "Admin " + businessName,
                password: adminUser.password, // hashed by hooks
                role: "ADMIN",
                isActive: true
            }, { transaction: t });

            // 3. Create Cashier User (Optional)
            if (cashierUser && cashierUser.username) {
                // Check duplicate for cashier
                const existingCashier = await User.findOne({
                    where: {
                        [Op.or]: [{ username: cashierUser.username }, { email: cashierUser.email }]
                    }
                });
                if (existingCashier) {
                    await t.rollback();
                    return ApiResponse.error(res, "Username/Email Kasir sudah digunakan di sistem", 409);
                }

                await User.create({
                    clientId: client.id,
                    username: cashierUser.username,
                    email: cashierUser.email,
                    name: cashierUser.name || "Kasir " + businessName,
                    password: cashierUser.password, // hashed by hooks
                    role: "KASIR",
                    isActive: true
                }, { transaction: t });
            }

            await t.commit(); // ✅ Commit Transaction

            // ✅ Auto-initialize default settings for new client (after commit)
            try {
                await Setting.initializeDefaults(client.id, {
                    businessName: client.businessName,
                    address: client.address,
                    phone: client.phone,
                });
                console.log(`✅ Default settings initialized for client: ${client.code}`);
            } catch (settingError) {
                console.error(`⚠️ Failed to initialize settings for client ${client.code}:`, settingError.message);
                // Don't fail the whole request, just log the error
            }

            return ApiResponse.created(res, client, "Client dan User Admin berhasil dibuat");
        } catch (error) {
            await t.rollback(); // ❌ Rollback if error
            next(error);
        }
    }

    // ============================================
    // PUT /api/clients/:id - Update client
    // ============================================
    static async update(req, res, next) {
        try {
            const { id } = req.params;
            const {
                code,
                businessName,
                ownerName,
                phone,
                address,
                status,
                subscriptionPlan,
                subscriptionEnd,
            } = req.body;

            const client = await Client.findByPk(id);
            if (!client) {
                return ApiResponse.notFound(res, "Client tidak ditemukan");
            }

            // Check code duplication if changed
            if (code && code !== client.code) {
                const existingCode = await Client.findOne({
                    where: {
                        code,
                        id: { [Op.ne]: id },
                    },
                });

                if (existingCode) {
                    return ApiResponse.validationError(
                        res,
                        { code: ["Kode client sudah digunakan oleh client lain"] },
                        "Kode client duplicate"
                    );
                }
            }

            await client.update({
                code: code || client.code,
                businessName: businessName || client.businessName,
                ownerName: ownerName || client.ownerName,
                phone: phone || client.phone,
                address: address || client.address,
                status: status || client.status,
                subscriptionPlan: subscriptionPlan || client.subscriptionPlan,
                subscriptionEnd: subscriptionEnd || client.subscriptionEnd,
            });

            return ApiResponse.success(res, client, "Data client berhasil diupdate");
        } catch (error) {
            next(error);
        }
    }

    // ============================================
    // DELETE /api/clients/:id - Delete client (Soft delete logic prefered maybe?)
    // For now we do physical delete but check constraints usually.
    // Assuming simple delete for now based on request.
    // ============================================
    static async delete(req, res, next) {
        try {
            const { id } = req.params;
            const client = await Client.findByPk(id);

            if (!client) {
                return ApiResponse.notFound(res, "Client tidak ditemukan");
            }

            await client.destroy();

            return ApiResponse.success(res, null, "Client berhasil dihapus");
        } catch (error) {
            // Handle FK constraints if needed
            if (error.name === 'SequelizeForeignKeyConstraintError') {
                return ApiResponse.error(res, "Tidak dapat menghapus client karena masih memiliki data terkait (User/Data lain). Silakan nonaktifkan status client saja.", 400);
            }
            next(error);
        }
    }
}

module.exports = ClientController;
