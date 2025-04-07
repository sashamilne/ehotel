const express = require('express');
const router = express.Router();
const db = require('../db');

// Client sign-up
router.post('/signup/client', async (req, res) => {
  const { sin, name, email, password } = req.body;
  try {
    await db.query(
      'INSERT INTO Client (sin, full_name, email, password) VALUES ($1, $2, $3, $4)',
      [sin, name, email, password]
    );
    res.send('Client signed up successfully!');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error signing up client.');
  }
});

// Employee sign-up
router.post('/signup/employee', async (req, res) => {
  const { sin, name, email, password } = req.body;
  try {
    await db.query(
      'INSERT INTO Employee (sin, full_name, email, password) VALUES ($1, $2, $3, $4)',
      [sin, name, email, password]
    );
    res.send('Employee signed up successfully!');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error signing up employee.');
  }
});

module.exports = router;
