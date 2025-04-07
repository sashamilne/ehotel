const express = require('express');
const session = require('express-session');
const path = require('path');
const router = express.Router();
const pool = require('../db'); // PostgreSQL pool


// Route to fetch hotel chains from the database
router.get('/hotel-chains', async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM ehotelschema.hotel_chain'); // Assuming you have a `hotel_chains` table
      const hotelChains = result.rows;
  
      // Send the hotel chains as a JSON response
      res.json({ hotelChains });
    } catch (err) {
      console.error('Error fetching hotel chains:', err);
      res.status(500).json({ error: 'Failed to fetch hotel chains' });
    }
  });

// Route to fetch hotels by chain ID
router.get('/hotels_by_chainID/:chainId', async (req, res) => {
    const { chainId } = req.params;
    console.log("Chain ID:", chainId); // Log the chain ID for debugging
    try {
        const result = await pool.query('SELECT * FROM ehotelschema.hotel WHERE chain_id = $1', [chainId]);
        const hotels = result.rows;

        // Send the hotels as a JSON response
        res.json({ hotels });
    } catch (err) {
        console.error('Error fetching hotels:', err);
        res.status(500).json({ error: 'Failed to fetch hotels' });
    }
});

// Route to fetch rooms by hotel ID
router.get('/rooms_by_hotelID/:hotelId', async (req, res) => {

    const { hotelId } = req.params;
    try {
        const result = await pool.query('SELECT * FROM ehotelschema.room WHERE hotel_id = $1', [hotelId]);
        const rooms = result.rows;
        console.log("Rooms:", rooms); // Log the rooms for debugging

        // Send the rooms as a JSON response
        res.json({ rooms });
    } catch (err) {
        console.error('Error fetching rooms:', err);
        res.status(500).json({ error: 'Failed to fetch rooms' });
    }
}

);

router.get('/reservations-by-clientID', async (req, res) => {
    const clientId = req.session.user.SIN; // Assuming the client ID is stored in the session
    try {
        const result = await pool.query('SELECT * FROM ehotelschema.reservation WHERE sin = $1', [clientId]);
        const reservations = result.rows;
        console.log("Reservations:", reservations); // Log the reservations for debugging

        // Send the reservations as a JSON response
        res.json({ reservations });
    } catch (err) {
        console.error('Error fetching reservations:', err);
        res.status(500).json({ error: 'Failed to fetch reservations' });
    }
}
);


  


module.exports = router;