const express = require('express');
const router = express.Router();
const pool = require('../db');
const { ServerResponse } = require('http');

// POST /confirm-reservation
router.post('/confirm-reservation', async (req, res) => {
  const { check_in, check_out, room_type, hotel_id, room_number } = req.body;
  console.log(req.body);
  console.log(req.session.user);
  const parsedRoomNumber = parseInt(room_number);

  const user = req.session.user;
  if (!user || user.SIN == null) {
    return res.status(401).send('User not logged in.');
  }

  if (user.role != 'client') {
    return res.status(403).send('Unauthorized access.');
  }

  // Validate dates
  if (new Date(check_in) >= new Date(check_out)) {
    return res.status(400).send('Check-in must be before check-out.');
  }

  const today = new Date();
  const balanceDue = 0;
  // get price
  try {
    const result = await pool.query(
      `SELECT * FROM ehotelschema.room WHERE hotel_id = $1 AND room_number = $2`,
      [hotel_id, parsedRoomNumber]
    );
    const room = result.rows[0];
    balanceDue = room.price;
    const timeDifference = checkOut - checkIn;
    const daysDifference = Math.ceil(timeDifference / (1000 * 3600 * 24));
    balanceDue *= daysDifference;
    console.log('Balance Due:', balanceDue);
  } catch (err) {
}


  try {
    await pool.query(
      `INSERT INTO ehotelschema.reservation (sin, hotel_id, room_number, check_in_date, check_out_date, reservation_date, balance_due)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [user.SIN, hotel_id, parsedRoomNumber, check_in, check_out, today, balanceDue]
    );
    res.redirect('/client-dashboard');
  } catch (err) {
    console.error('Error inserting reservation:', err);
    res.status(500).send('Server error');
  }
});

module.exports = router;
