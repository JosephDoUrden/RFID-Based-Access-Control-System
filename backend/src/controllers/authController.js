const UserModel = require("../models/userModel");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const AuthController = {};

AuthController.register = (req, res) => {
  const { username, password } = req.body;
  UserModel.createUser(username, password, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).send("Registration failed");
      return;
    }
    res.status(200).send("Registration successful");
  });
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
      expiresIn: 86400,
    }); // Expires in 24 hours
    res.status(200).send({ auth: true, token: token });
  });
};

module.exports = AuthController;
