const express = require("express");
const router = express.Router();
const { requireAuth } = require("../middleware/authMiddleware");
const UserModel = require("../models/userModel");

router.get("/", requireAuth, (req, res) => {
  // Eğer kullanıcı giriş yaptıysa, erişim izni ver
  const user = UserModel.getUserByEmail(req.user.email, (err, user) => {
    if (err) {
      console.error("Error:", err);
      return;
    }
    console.log("User:", user);
    res.status(200).send(user);
  });
});

module.exports = router;
