const UserModel = require("../models/userModel");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const Mailer = require("../config/mailer");

const AuthController = {};

AuthController.register = (req, res) => {
  const { username, name, surname, email, password } = req.body;
  UserModel.createUser(
    username,
    name,
    surname,
    email,
    password,
    (err, results) => {
      if (err) {
        console.error(err);
        if (err === "Username already taken") {
          res.status(400).send("Username already taken");
        } else if (err === "Email already registered") {
          res.status(400).send("Email already registered");
        } else {
          res.status(500).send("Registration failed");
        }
        return;
      }
      res.status(200).send("Registration successful");
    }
  );
};

AuthController.login = (req, res) => {
  const { username, password } = req.body;
  console.log("Received username:", username);
  console.log("Received password:", password);

  UserModel.getUserByUsername(username, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).send("Login failed");
      return;
    }
    console.log("User data from database:", results);

    if (results.length === 0) {
      console.log("Invalid username or password - no user data found");
      res.status(401).send("Invalid username or password");
      return;
    }

    const user = results[0];
    if (!user.Password) {
      console.log(
        "Invalid username or password - password not found in user data"
      );
      res.status(401).send("Invalid username or password");
      return;
    }

    const hashedPassword = user.Password;
    console.log("Hashed password from database:", hashedPassword);

    if (!bcrypt.compareSync(password, hashedPassword)) {
      console.log("Invalid username or password - password comparison failed");
      res.status(401).send("Invalid username or password");
      return;
    }

    console.log("User authenticated successfully!");
    const token = jwt.sign({ id: user.UserID }, "secretkey", {
      expiresIn: 86400, // Expires in 24 hours
    });
    res.status(200).send({ auth: true, token: token });
  });
};

// Forgot password
AuthController.forgotPassword = async (req, res) => {
  const { email } = req.body;

  try {
    // Check if the user with the provided email exists
    await UserModel.getUserByEmail(email, (err, user) => {
      if (err) {
        console.error("Error:", err);
        return res.status(404).json({ error: err });
      }
    });

    // Generate 6-digit reset code
    const resetCode = generateRandomCode(6);

    // Save the reset code in the database
    await UserModel.saveResetCode(email, resetCode);

    // Send the reset code to the user via email
    await Mailer.sendResetCodeEmail(email, resetCode);

    // Return success response
    res.status(200).json({ message: "Reset code sent successfully" });
  } catch (error) {
    console.error("Error sending reset code:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Reset password
AuthController.resetPassword = async (req, res) => {
  const { email, resetCode, newPassword } = req.body;

  try {
    // Check if the reset code is valid
    const isValidCode = await UserModel.isValidResetCode(email, resetCode);
    if (!isValidCode) {
      return res.status(400).json({ error: "Invalid reset code" });
    }

    await UserModel.updatePassword(email, newPassword);

    // Delete the reset code from the database
    await UserModel.deleteResetCode(email);

    // Return success response
    res.status(200).json({ message: "Password reset successfully" });
  } catch (error) {
    console.error("Error resetting password:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

// Function to generate a unique reset password x-digit code
function generateRandomCode(length) {
  const charset = "0123456789"; // Define the character set for the code
  let code = "";
  for (let i = 0; i < length; i++) {
    const randomIndex = Math.floor(Math.random() * charset.length);
    code += charset[randomIndex];
  }
  return code;
}

module.exports = AuthController;
