require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const path = require("path");
const { OpenAI } = require("openai");
const { hash } = require("crypto");

const app = express();

// ENV Variables
const PORT = process.env.PORT || 3000;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const DEV_ENV = process.env.DEV_ENV === "DEVELOPMENT";

// Authentication Middleware
const authenticateUser = require('./middleware/authenticateUser');

// Defined routes
const apiRoutes = require('./routes/test_auth_requests');

// Define middleware for specific route
app.use('/api', authenticateUser);

// Mount file to route
app.use('/api', apiRoutes);

// Add JSON to responses
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.listen(PORT, () => {
  if (DEV_ENV) console.log("Detected development environment!");

  console.log(`Server is running on http://localhost:${PORT}`);
});
