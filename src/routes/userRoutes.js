const express = require("express");
const router = express.Router();
const UserController = require("../controllers/UserController");
const { authenticate, authorize } = require("../middlewares/auth");

// Protect all routes
router.use(authenticate);

// List All Users & Detail
// Accessible by SUPER_ADMIN & ADMIN
router.get("/", authorize(["SUPER_ADMIN", "ADMIN"]), UserController.getAll);
router.post("/", authorize(["SUPER_ADMIN", "ADMIN"]), UserController.create);
router.get("/:id", authorize(["SUPER_ADMIN", "ADMIN"]), UserController.getById);

// Update & Delete
router.put("/:id", authorize(["SUPER_ADMIN", "ADMIN"]), UserController.update);
router.delete("/:id", authorize(["SUPER_ADMIN", "ADMIN"]), UserController.delete);

// Reset Password & Status Update
router.post("/:id/reset-password", authorize(["SUPER_ADMIN", "ADMIN"]), UserController.resetPassword);
router.patch("/:id/status", authorize(["SUPER_ADMIN", "ADMIN"]), UserController.updateStatus);

module.exports = router;
