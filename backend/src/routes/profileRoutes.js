// profileRoutes.js

const express = require("express");
const router = express.Router();
const UserModel = require("../models/userModel");
const { requireAuth } = require("../middleware/authMiddleware");
const bcrypt = require("bcrypt");

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

// Route to change user password
router.put("/change-password", requireAuth, (req, res) => {
  const { oldPassword, newPassword } = req.body;

  // First, retrieve the user's current password from the database
  UserModel.getUserById(req.userId, (err, user) => {
    if (err) {
      return res.status(500).json({ error: "Internal Server Error" });
    }
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Compare the old password provided by the user with the password stored in the database
    bcrypt.compare(oldPassword, user.password, (err, isMatch) => {
      if (err) {
        return res.status(500).json({ error: "Internal Server Error" });
      }
      if (!isMatch) {
        // If the old password provided does not match the one stored in the database
        return res.status(400).json({ error: "Old password is incorrect" });
      }

      // If the old password is correct, proceed to update the password
      UserModel.changePassword(req.userId, newPassword, (err) => {
        if (err) {
          return res.status(500).json({ error: "Internal Server Error" });
        }
        // Return success message
        res
          .status(200)
          .json({ success: true, message: "Password changed successfully" });
      });
    });
  });
});

module.exports = router;
