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
    const formatTimestamp = (timestamp) => {
      const date = new Date(timestamp);
      return date.toLocaleString("tr-TR", { timeZone: "UTC" }); // Adjust timezone as needed
    };

    // Update timestamps in userLogData
    userLogData.TimseStamp = formatTimestamp(userLogData.TimseStamp);
    userLogData.Date = formatTimestamp(userLogData.Date);
    // Return user log data
    res.status(200).json(userLogData);
  });
});

// Route to get permissions
router.get("/permissions", requireAuth, (req, res) => {
  //get permissions
  UserModel.getPermissions((err, permissions) => {
    if (err) {
      return res.status(500).json({ error: "Internal Server Error" });
    }
    if (!permissions) {
      return res.status(404).json({ error: "Permissions not found" });
    }

    // Return user log data
    res.status(200).json(permissions);
  });
});

// Route to update permissions
router.put("/update-permission", requireAuth, (req, res) => {
  //update permissions
  const { permissionID, newPermission } = req.body;
  
  // update the permission
  UserModel.updatePermission(permissionID, newPermission, (err) => {
    if (err) {
      return res.status(500).json({ error: "Failed to update permission" });
    }
    // Return success message
    res
      .status(200)
      .json({ success: true, message: "Permission changed successfully" });
  });
});

module.exports = router;
