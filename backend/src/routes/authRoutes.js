const express = require("express");
const router = express.Router();
const AuthController = require("../controllers/authController");
const { requireAuth } = require("../middleware/authMiddleware");

router.post("/register", AuthController.register);
router.post("/login", AuthController.login);
router.post("/logout", requireAuth, (req, res) => {
  // Assuming you have stored the JWT token in a cookie named 'jwt'
  res.clearCookie("jwt");
  res.status(200).json({ message: "Logout successful" });
});

module.exports = router;
