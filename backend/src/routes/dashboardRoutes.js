const express = require("express");
const router = express.Router();
const { requireAuth } = require("../middleware/authMiddleware");
const UserModel = require("../models/userModel");

router.get("/", requireAuth, (req, res) => {
  // Eğer kullanıcı giriş yaptıysa, erişim izni ver
  //res.status(200).send("Dashboard Page - Only accessible by logged-in users");
  const user = UserModel.getUserByEmail(
    "yusufhansacak@icloud.com",
    (err, user) => {
      if (err) {
        console.error("Error:", err);
        return;
      }
      console.log("User:", user);
      res.status(200).send(user);
    }
  );
});

module.exports = router;
