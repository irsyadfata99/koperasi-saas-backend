const express = require("express");
const router = express.Router();
const ClientController = require("../controllers/ClientController");
const { authenticate, authorize } = require("../middlewares/auth");

// Only SUPER_ADMIN can manage clients
router.use(authenticate);
router.use(authorize(["SUPER_ADMIN"]));

router.get("/", ClientController.getAll);
router.get("/:id", ClientController.getById);
router.post("/", ClientController.create);
router.put("/:id", ClientController.update);
router.delete("/:id", ClientController.delete);

module.exports = router;
