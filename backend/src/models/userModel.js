const connection = require("../config/db");
const bcrypt = require("bcryptjs");

const UserModel = {};

UserModel.createUser = (
  username,
  firstname,
  lastname,
  email,
  password,
  callback
) => {
  const hashedPassword = bcrypt.hashSync(password, 8);
  connection.query(
    "INSERT INTO users (username, firstname, lastname, email, password) VALUES (?, ?, ?, ?, ?)",
    [username, firstname, lastname, email, hashedPassword],
    callback
  );
};

UserModel.getUserByUsername = (username, callback) => {
  connection.query(
    "SELECT * FROM users WHERE username = ?",
    [username],
    callback
  );
};

module.exports = UserModel;
