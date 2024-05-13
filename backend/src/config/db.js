const mysql = require("mysql");

const connection = mysql.createConnection({
  host: "195.35.28.226",
  user: "remote", // MySQL username
  password: "remote123", // MySQL password
  database: "rfid-based-access-control", // db name
});

connection.connect((err) => {
  if (err) {
    console.error("Database connection failed: " + err.stack);
    return;
  }
  console.log("Connected to database.");
});

module.exports = connection;
