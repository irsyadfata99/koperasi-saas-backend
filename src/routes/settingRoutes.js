// src/routes/settingRoutes.js
const express = require("express");
const router = express.Router();
const SettingController = require("../controllers/SettingController");
const { authenticate, authorize } = require("../middlewares/auth");

// Protect all routes
router.use(authenticate);

// Get all settings / by group
router.get("/", authorize(["SUPER_ADMIN", "ADMIN", "KASIR"]), SettingController.getAll);

// Get single setting by key
router.get("/:key", authorize(["SUPER_ADMIN", "ADMIN", "KASIR"]), SettingController.getByKey);

// Bulk update
router.put("/bulk", authorize(["SUPER_ADMIN", "ADMIN"]), SettingController.bulkUpdate);

// Update single setting
router.put("/:key", authorize(["SUPER_ADMIN", "ADMIN"]), SettingController.update);

// Initialize defaults
router.post("/initialize", authorize(["SUPER_ADMIN", "ADMIN"]), SettingController.initialize);

// Delete setting
router.delete("/:key", authorize(["SUPER_ADMIN", "ADMIN"]), SettingController.delete);

module.exports = router;
