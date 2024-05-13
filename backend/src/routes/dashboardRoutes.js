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

// Route to get user logs
router.get("/logs", requireAuth, (req, res) => {
  //get user logs based on user ID stored in req.userId
  UserModel.getUserLogById(req.userId, (err, userLogData) => {
    if (err) {
      return res.status(500).json({ error: "Internal Server Error" });
    }
    if (!userLogData) {
      return res.status(404).json({ error: "User not found" });
    }
    // Return user log data
    res.status(200).json(userLogData);
    
  });
});

module.exports = router;
