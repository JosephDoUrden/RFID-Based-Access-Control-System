const mysql = require("mysql");

const connection = mysql.createConnection({
  host: "localhost",
  user: "root", // MySQL username
  password: "", // MySQL password
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
