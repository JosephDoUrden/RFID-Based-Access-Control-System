const UserModel = require("../models/userModel");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const crypto = require("crypto");

const AuthController = {};

AuthController.register = (req, res) => {
  const { username, firstname, lastname, email, password } = req.body;
  UserModel.createUser(
    username,
    firstname,
    lastname,
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
  UserModel.getUserByUsername(username, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).send("Login failed");
      return;
    }
    if (
      results.length === 0 ||
      !bcrypt.compareSync(password, results[0].password)
    ) {
      res.status(401).send("Invalid username or password");
      return;
    }
    const token = jwt.sign({ id: results[0].id }, "secretkey", {
      expiresIn: 86400, // Expires in 24 hours
    });
    res.status(200).send({ auth: true, token: token });
  });
};

// Forgot password
AuthController.forgotPassword = async (req, res) => {
  const { email } = req.body;
  // Generate a unique reset password token
  const resetToken = generateResetToken();
  // Calculate expiration date for the token (e.g., 1 hour from now)
  const expirationDate = new Date(Date.now() + 3600000); // 1 hour in milliseconds

  // Store the reset token and its expiration date in the database
  UserModel.generateResetPasswordToken(
    email,
    resetToken,
    expirationDate,
    (err, result) => {
      if (err) {
        console.error("Error generating reset password token:", err);
        return res.status(500).json({ error: "Internal Server Error" });
      }

      // Send an email to the user with instructions for resetting their password
      sendResetPasswordEmail(email, resetToken);

      res
        .status(200)
        .json({ message: "Reset password instructions sent to your email" });
    }
  );
};

// Reset password
AuthController.resetPassword = async (req, res) => {
  const { email, token, newPassword } = req.body;

  // Verify if the reset token is valid and not expired
  UserModel.getUserByResetPasswordToken(token, (err, user) => {
    if (err) {
      console.error("Error verifying reset password token:", err);
      return res.status(500).json({ error: "Internal Server Error" });
    }

    if (!user) {
      // Invalid or expired token
      return res
        .status(400)
        .json({ error: "Invalid or expired reset password token" });
    }

    // Update user's password and clear the reset password token
    UserModel.updatePasswordAndClearToken(
      user.id,
      newPassword,
      (err, result) => {
        if (err) {
          console.error("Error updating password:", err);
          return res.status(500).json({ error: "Internal Server Error" });
        }

        res.status(200).json({ message: "Password updated successfully" });
      }
    );
  });
};

// Function to generate a unique reset password token
function generateResetToken() {
  return new Promise((resolve, reject) => {
    crypto.randomBytes(20, (err, buffer) => {
      if (err) {
        reject(err);
      } else {
        const token = buffer.toString("hex");
        resolve(token);
      }
    });
  });
}

// Function to send reset password email
function sendResetPasswordEmail(email, token) {
  // Create a nodemailer transporter using SMTP or other transport methods
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "your-email@gmail.com",
      pass: "your-email-password",
    },
  });

  // Define email options
  const mailOptions = {
    from: "your-email@gmail.com",
    to: email,
    subject: "Password Reset",
    text: `You are receiving this email because you (or someone else) have requested to reset your password. Please click on the following link to reset your password: http://yourdomain.com/reset/${token}`,
  };

  // Send the email
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log("Error occurred while sending email:", error);
    } else {
      console.log("Email sent:", info.response);
    }
  });
}

module.exports = AuthController;
