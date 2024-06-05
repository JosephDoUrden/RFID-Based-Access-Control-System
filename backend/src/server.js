const express = require("express"); //Framework for building web applications
const bodyParser = require("body-parser"); //Middleware to parse incoming request bodies
const authRoutes = require("./routes/authRoutes"); //Routes for authentication-related endpoints
const dashboardRoutes = require("./routes/dashboardRoutes"); //Routes for dashboard-related endpoints
const { requireAuth } = require("./middleware/authMiddleware"); //Middleware to ensure routes are accessed by authenticated users
const profileRoutes = require("./routes/profileRoutes"); //Routes for user profile-related endpoints

const app = express();
const PORT = process.env.PORT || 3000; //uses the value from environment variables or defaults to 3000

app.use(bodyParser.json()); //parse JSON request bodies, making the data available in req.body

// Auth routes
app.use("/api/auth", authRoutes);

// Dashboard routes (requires authentication)
app.use("/api/dashboard", requireAuth, dashboardRoutes);

// Profile routes (requires authentication)
app.use("/api/profile", requireAuth, profileRoutes); // Use profileRoutes

//Starts the server on the specified port and logs a message indicating the server is running
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
