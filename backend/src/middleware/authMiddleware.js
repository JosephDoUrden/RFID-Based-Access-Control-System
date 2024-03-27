const jwt = require("jsonwebtoken");

const requireAuth = (req, res, next) => {
  const token = req.headers.authorization;

  if (token) {
    jwt.verify(token, "secretkey", (err, decodedToken) => {
      if (err) {
        return res.status(401).json({ error: "Unauthorized" });
      } else {
        req.userId = decodedToken.id;
        next();
      }
    });
  } else {
    return res.status(401).json({ error: "Unauthorized" });
  }
};

module.exports = { requireAuth };
