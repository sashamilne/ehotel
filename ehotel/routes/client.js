const express = require('express');
const session = require('express-session');
const path = require('path');
const router = express.Router();
const pool = require('../db'); // PostgreSQL pool


// Middleware to check if the user is logged in (has session data)
const checkSession = (req, res, next) => {
    //console.log(req.session);  // Log session to see if it's being set correctly
    if (!req.session.user || req.session.user.SIN == null) {
        return res.status(401).json({ error: 'Unauthorized: No user session found' });
    }
    next();
};

// Apply the session check middleware to all routes
router.use(checkSession);

// Render the update-client.html page
router.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../public/update-client.html'));  // Adjust the path based on your file structure
});

// Update First Name
router.post('/first-name', async (req, res) => {
    const CLIENT_ID = req.session.user.SIN;
    const { first_name } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.client SET first_name = $1 WHERE SIN = $2', [first_name, CLIENT_ID]);
        req.flash('success', 'First name updated successfully');
        res.redirect('/update-client?success=First name updated successfully');
    } catch (err) {
        res.redirect('/update-client?error=Error updating first name');
    }
});

// Update Last Name
router.post('/last-name', async (req, res) => {
    const CLIENT_ID = req.session.user.SIN;
    const { last_name } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.client SET last_name = $1 WHERE SIN = $2', [last_name, CLIENT_ID]);
        res.redirect('/update-client?success=Last name updated successfully');
    } catch (err) {
        res.redirect('/update-client?error=Error updating last name');
    }
});

// Update SIN
router.post('/sin', async (req, res) => {
    const CLIENT_ID = req.session.user.SIN;
    const { sin } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.client SET sin = $1 WHERE sin = $2', [sin, CLIENT_ID]);
        // Update the session with the new SIN
        req.session.user.SIN = sin;
        res.redirect('/update-client?success=SIN updated successfully');
    } catch (err) {
        res.redirect('/update-client?error=Error updating SIN');
    }
});

// Update Phone Number
router.post('/phone-number', async (req, res) => {
    const CLIENT_ID = req.session.user.SIN;
    const { phone_number } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.client SET phone_number = $1 WHERE sin = $2', [phone_number, CLIENT_ID]);
        req.flash('success', 'Phone number updated successfully');
        res.redirect('/update-client');
    } catch (err) {
        req.flash('error', 'Error updating phone number: ' + err.message);
        res.redirect('/update-client');
    }
});

// Update Email
router.post('/email', async (req, res) => {
    const CLIENT_ID = req.session.user.SIN;
    const { email } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.client SET email = $1 WHERE sin = $2', [email, CLIENT_ID]);
        req.flash('success', 'Email updated successfully');
        res.redirect('/update-client');
    } catch (err) {
        req.flash('error', 'Error updating email: ' + err.message);
        res.redirect('/update-client');
    }
});

module.exports = router;