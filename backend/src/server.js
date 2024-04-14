const express = require("express");
const bodyParser = require("body-parser");
const authRoutes = require("./routes/authRoutes");
const dashboardRoutes = require("./routes/dashboardRoutes");
const { requireAuth } = require("./middleware/authMiddleware");
const profileRoutes = require("./routes/profileRoutes");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

// Auth routes
app.use("/api/auth", authRoutes);

// Dashboard routes (requires authentication)
app.use("/api/dashboard", requireAuth, dashboardRoutes);

// Profile routes (requires authentication)
app.use("/api/profile", requireAuth, profileRoutes); // Use profileRoutes

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
