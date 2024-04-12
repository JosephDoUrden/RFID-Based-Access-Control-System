// profileRoutes.js

const express = require("express");
const router = express.Router();
const UserModel = require("../models/userModel");
const { requireAuth } = require("../middleware/authMiddleware");

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

// Route to update user profile
router.put("/", requireAuth, (req, res) => {
  const { username, firstname, lastname, email } = req.body;
  // Update user details in the database
  UserModel.updateUser(
    req.userId,
    username,
    firstname,
    lastname,
    email,
    (err, updatedUser) => {
      if (err) {
        return res.status(500).json({ error: "Internal Server Error" });
      }
      if (!updatedUser) {
        return res.status(404).json({ error: "User not found" });
      }
      // Return success message
      res
        .status(200)
        .json({ success: true, message: "User details updated successfully" });
    }
  );
});

module.exports = router;
