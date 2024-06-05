const nodemailer = require("nodemailer");
require("dotenv").config();

// Create a nodemailer transporter with SMTP transport
const transporter = nodemailer.createTransport({
  service: "Gmail", // Gmail SMTP server
  host: "smtp.gmail.com", // SMTP server host
  port: 465, // SMTP port (default: 587 for TLS)
  secure: true, // Use secure connection (TLS)
  auth: {
    user: process.env.EMAIL_ADDRESS, // Email address
    pass: process.env.EMAIL_PASSWORD, // App password
  },
});

// Function to send reset code email
async function sendResetCodeEmail(email, resetCode) {
  try {
    // Send email using nodemailer transporter
    await transporter.sendMail({
      from: process.env.EMAIL_ADDRESS, // Sender email address
      to: email, // Recipient email address
      subject: "Password Reset Code", // Email subject
      text: `Your password reset code is: ${resetCode}`, // Email body
    });
    console.log("Reset code email sent successfully");
  } catch (error) {
    console.error("Error occurred while sending email:", error);
    throw error;
  }
}

// Function to send reset code email
async function sendReportEmail(email, subject, issue) {
  try {
    // Send email using nodemailer transporter
    await transporter.sendMail({
      from: process.env.EMAIL_ADDRESS, // Sender email address
      to: email, // Recipient email address
      subject: subject, // Email subject
      text: issue, // Email body
    });
    console.log("Report email sent successfully");
  } catch (error) {
    console.error("Error occurred while sending email:", error);
    throw error;
  }
}

module.exports = { sendResetCodeEmail, sendReportEmail };
