require('dotenv').config();
const { Pool } = require('pg');

// Create a new PostgreSQL connection pool
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT
});

// Test the database connection
pool.connect()
  .then(() => console.log("Connected to PostgreSQL."))
  .catch(err => console.error("Connection error: ", err));

module.exports = pool;