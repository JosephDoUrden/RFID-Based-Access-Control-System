const connection = require("../config/db");
const bcrypt = require("bcryptjs");

const UserModel = {};

UserModel.createUser = (username, name, surname, email, password, callback) => {
  // Check if username or email already exists
  UserModel.getUserByUsername(username, (err, existingUsername) => {
    if (err) {
      return callback(err);
    }
    if (existingUsername && existingUsername.length > 0) {
      // Username already exists
      return callback("Username already taken");
    } else {
      // Check if email exists
      UserModel.getUserByEmail(email, (err, existingEmail) => {
        if (err) {
          return callback(err);
        }
        if (existingEmail && existingEmail.length > 0) {
          // Email already exists
          return callback("Email already registered");
        } else {
          // Proceed with user creation
          // Get the last UserID from the database
          connection.query(
            "SELECT MAX(UserID) AS LastUserID FROM user",
            (err, result) => {
              if (err) {
                // Handle error
                return callback(err);
              }
              // Extract the last UserID
              const lastUserID = result[0].LastUserID;
              // Increment it by one
              const nextUserID = lastUserID + 1;
              const roleId = 2;
              const cardId = "B3E05225";
              // Proceed with user creation
              const hashedPassword = bcrypt.hashSync(password, 8);
              connection.query(
                "INSERT INTO user (UserID, Username, Name, Surname, RoleID, CardID, Email, Password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                [
                  nextUserID,
                  username,
                  name,
                  surname,
                  roleId,
                  cardId,
                  email,
                  hashedPassword,
                ],
                callback
              );
            }
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
  connection.query("SELECT * FROM user WHERE Email = ?", [email], callback);
};

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

UserModel.updateUser = (userId, username, name, surname, email, callback) => {
  connection.query(
    "UPDATE user SET Username = ?, Name = ?, Surname = ?, Email = ? WHERE UserID = ?",
    [username, name, surname, email, userId],
    callback
  );
};

UserModel.changePassword = (userId, newPassword, callback) => {
  const hashedPassword = bcrypt.hashSync(newPassword, 8);
  connection.query(
    "UPDATE user SET Password = ? WHERE UserID = ?",
    [hashedPassword, userId],
    callback
  );
};

UserModel.updatePassword = (email, newPassword, callback) => {
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

// Get user log data by ID
UserModel.getUserLogById = (userId, callback) => {
  connection.query(
    "SELECT access_log.*, gate.GateName, gate.Location FROM access_log JOIN gate ON access_log.GateID = gate.GateID WHERE access_log.UserID = ?",
    [userId],
    (err, logs) => {
      if (err) {
        return callback(err);
      }
      // Return logs data
      callback(null, logs);
    }
  );
};

module.exports = UserModel;
