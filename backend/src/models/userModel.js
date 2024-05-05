const connection = require("../config/db");
const bcrypt = require("bcryptjs");

const UserModel = {};

UserModel.createUser = (
  username,
  name,
  surname,
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
            "INSERT INTO user (Username, Name, Surname, Email, Password) VALUES (?, ?, ?, ?, ?)",
            [username, name, surname, email, hashedPassword],
            callback
          );
        }
      });
    }
  });
};

UserModel.getUserByUsername = (username, callback) => {
  connection.query(
    "SELECT * FROM user WHERE Username = ?",
    [username],
    callback
  );
};

UserModel.getUserByEmail = (email, callback) => {
  connection.query(
    "SELECT * FROM user WHERE Email = ?",
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
    "SELECT * FROM user WHERE UserID = ?",
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
  name,
  surname,
  email,
  callback
) => {
  connection.query(
    "UPDATE users SET Username = ?, Name = ?, Surname = ?, Email = ? WHERE UserID = ?",
    [username, name, surname, email, userId],
    callback
  );
};

// Update user password
UserModel.changePassword = (userId, newPassword, callback) => {
  // Hash the new password
  const hashedPassword = bcrypt.hashSync(newPassword, 8);
  connection.query(
    "UPDATE user SET Password = ? WHERE UserID = ?",
    [hashedPassword, userId],
    callback
  );
};

// Update user password
UserModel.updatePassword = (email, newPassword, callback) => {
  // Hash the new password
  const hashedPassword = bcrypt.hashSync(newPassword, 8);

  connection.query(
    "UPDATE user SET Password = ? WHERE Email = ?",
    [hashedPassword, email],
    callback
  );
};

// Save reset code in the database
UserModel.saveResetCode = (email, resetCode, callback) => {
  connection.query(
    "INSERT INTO reset_codes (Email, ResetCode) VALUES (?, ?)",
    [email, resetCode],
    callback
  );
};

// Check if reset code is valid
UserModel.isValidResetCode = (email, resetCode) => {
  return new Promise((resolve, reject) => {
    connection.query(
      "SELECT * FROM reset_codes WHERE Email = ? AND ResetCode = ?",
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
    "DELETE FROM reset_codes WHERE Email = ?",
    [email],
    callback
  );
};

module.exports = UserModel;
