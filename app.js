// https://www.magalix.com/blog/how-to-integrate-opa-into-your-kubernetes-cluster-using-kube-mgmt
require("dotenv").config();

const axios = require("axios");
const express = require("express");
const jwt = require("jsonwebtoken");

const app = express();

app.use(express.json());

app.get("/token", (req, res) => {
  const email = req.query.email;
  const role = email === "admin@cool-corp.com" ? "admin" : "user";

  const token = jwt.sign({ email, role }, process.env.TOKEN_KEY, {
    expiresIn: role === "admin" ? "2h" : 5,
  });

  res.status(201).json({ token });
});

app.use("/data", function (req, res, next) {
  const action = req.query.action;
  const token = req.get("Authorization").substring("Bearer ".length);
  axios
    .post(`http://localhost:8181/v1/data`, { input: { token } })
    .then((result) => {
      if (result.status !== 200) {
        res.status(500).send(`Internal OPA error: ${result.status} status`);
      } else if (action !== "read" && action !== "write") {
        res.status(400).send(`Wrong action ${action}: 'read' and 'write' just supported`);
      } else if (result.data.result.auth.denial_reasons.length > 0) {
        res.status(401).send(result.data.result.auth.denial_reasons);
      } else if (!result.data.result.content.allow_read && action === "read") {
        res.status(401).send(`Impossible to read`);
      } else if (!result.data.result.content.allow_write && action === "write") {
        res.status(401).send(`Impossible to write`);
      } else {
        next();
      }
    })
    .catch((error) => {
      res.status(500).send(`Internal error: ${error}`);
    });
});

app.get("/data", (req, res) => {
  res.status(201).json({ time: new Date(), result: `'${req.query.action} OK'` });
});

module.exports = app;
