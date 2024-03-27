const express = require("express");
const router = express.Router();
const { requireAuth } = require("../middleware/authMiddleware");

router.get("/", requireAuth, (req, res) => {
  // Eğer kullanıcı giriş yaptıysa, erişim izni ver
  res.status(200).send("Dashboard Page - Only accessible by logged-in users");
});

module.exports = router;
