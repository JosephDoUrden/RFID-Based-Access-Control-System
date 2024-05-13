const express = require("express");
const router = express.Router();
const { requireAuth } = require("../middleware/authMiddleware");
const UserModel = require("../models/userModel");

// Route to get user profile data
router.get("/", requireAuth, (req, res) => {
  // Get user data based on user ID stored in req.userId
  UserModel.getUserById(req.userId, (err, userData) => {
    if (err) {
      return res.status(500).json({ error: "Internal Server Error" });
    }
    if (!userData) {
      return res.status(404).json({ error: "User not found" });
    }
    // Return user data
    res.status(200).json(userData);
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
