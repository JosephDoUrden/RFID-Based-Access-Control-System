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
  // Check if username or email already exists
  UserModel.getUserByUsername(username, (err, existingUsername) => {
    if (err) {
      return callback(err);
    }
    if (existingUsername.length > 0) {
      // Username already exists
      return callback("Username already taken");
    } else {
      // Check if email exists
      UserModel.getUserByEmail(email, (err, existingEmail) => {
        if (err) {
          return callback(err);
        }
        if (existingEmail.length > 0) {
          // Email already exists
          return callback("Email already registered");
        } else {
          // Proceed with user creation
          const hashedPassword = bcrypt.hashSync(password, 8);
          connection.query(
            "INSERT INTO users (username, firstname, lastname, email, password) VALUES (?, ?, ?, ?, ?)",
            [username, firstname, lastname, email, hashedPassword],
            callback
          );
        }
      });
    }
  });
};

UserModel.getUserByUsername = (username, callback) => {
  connection.query(
    "SELECT * FROM users WHERE username = ?",
    [username],
    callback
  );
};

UserModel.getUserByEmail = (email, callback) => {
  connection.query("SELECT * FROM users WHERE email = ?", [email], callback);
};

module.exports = UserModel;
