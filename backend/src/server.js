const express = require("express");
const bodyParser = require("body-parser");
const authRoutes = require("./routes/authRoutes");
const dashboardRoutes = require("./routes/dashboardRoutes");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());
app.use("/api/auth", authRoutes);
app.use("/api/dashboard", dashboardRoutes); // Dashboard rotası için erişim izni gerektirir

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
