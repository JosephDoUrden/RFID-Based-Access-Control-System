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
  connection.query(
    "SELECT * FROM users WHERE email = ?",
    [email],
    (err, result) => {
      if (err) {
        return callback(err, null);
      }
      // Return the user data if found
      if (result.length > 0) {
        return callback(null, result[0]); // Assuming email is unique, return the first user found
      } else {
        return callback(null, null); // If no user found, return null
      }
    }
  );
};

// Get user data by ID
UserModel.getUserById = (userId, callback) => {
  connection.query(
    "SELECT * FROM users WHERE id = ?",
    [userId],
    (err, user) => {
      if (err) {
        return callback(err);
      }
      if (user.length === 0) {
        return callback(null, null); // User not found
      }
      callback(null, user[0]);
    }
  );
};

// Update user details
UserModel.updateUser = (
  userId,
  username,
  firstname,
  lastname,
  email,
  callback
) => {
  connection.query(
    "UPDATE users SET username = ?, firstname = ?, lastname = ?, email = ? WHERE id = ?",
    [username, firstname, lastname, email, userId],
    callback
  );
};

// Update user password
UserModel.changePassword = (userId, newPassword, callback) => {
  // Hash the new password
  const hashedPassword = bcrypt.hashSync(newPassword, 8);
  connection.query(
    "UPDATE users SET password = ? WHERE id = ?",
    [hashedPassword, userId],
    callback
  );
};

// Update user password
UserModel.updatePassword = (email, newPassword, callback) => {
  // Hash the new password
  const hashedPassword = bcrypt.hashSync(newPassword, 8);

  connection.query(
    "UPDATE users SET password = ? WHERE email = ?",
    [hashedPassword, email],
    callback
  );
};

// Save reset code in the database
UserModel.saveResetCode = (email, resetCode, callback) => {
  connection.query(
    "INSERT INTO reset_codes (email, reset_code) VALUES (?, ?)",
    [email, resetCode],
    callback
  );
};

// Check if reset code is valid
UserModel.isValidResetCode = (email, resetCode) => {
  return new Promise((resolve, reject) => {
    connection.query(
      "SELECT * FROM reset_codes WHERE email = ? AND reset_code = ?",
      [email, resetCode],
      (err, result) => {
        if (err) {
          reject(err);
        } else {
          resolve(result.length > 0);
        }
      }
    );
  });
};

// Delete reset code from the database
UserModel.deleteResetCode = (email, callback) => {
  connection.query(
    "DELETE FROM reset_codes WHERE email = ?",
    [email],
    callback
  );
};

module.exports = UserModel;
