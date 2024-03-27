const mysql = require("mysql");

const connection = mysql.createConnection({
  host: "localhost",
  user: "root", // MySQL kullanıcı adı
  password: "password", // MySQL şifre
  database: "mydatabase", // veritabanı adı
});

connection.connect((err) => {
  if (err) {
    console.error("Database connection failed: " + err.stack);
    return;
  }
  console.log("Connected to database.");
});

module.exports = connection;
