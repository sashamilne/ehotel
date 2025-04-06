const express = require('express');
const session = require('express-session');
const path = require('path');
const router = express.Router();
const pool = require('../db'); // PostgreSQL pool

// Middleware to check if the user is logged in (has session data)
const checkSession = (req, res, next) => {
    console.log(req.session);  // Log session to see if it's being set correctly
    if (!req.session.user || req.session.user.SIN == null) {
        return res.status(401).json({ error: 'Unauthorized: No user session found' });
    }
    next();
};

// Apply the session check middleware to all routes
router.use(checkSession);

// Render the update-employee.html page
router.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../public/update-employee.html'));  // Adjust the path based on your file structure
});

// Update First Name
router.post('/first-name', async (req, res) => {
    const EMPLOYEE_ID = req.session.user.SIN;
    const { first_name } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.employee SET first_name = $1 WHERE SIN = $2', [first_name, EMPLOYEE_ID]);
        res.redirect('/update-employee?success=First name updated successfully');
    } catch (err) {
        res.redirect('/update-employee?error=Error updating first name');
    }
});

// Update Last Name
router.post('/last-name', async (req, res) => {
    const EMPLOYEE_ID = req.session.user.SIN;
    const { last_name } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.employee SET last_name = $1 WHERE SIN = $2', [last_name, EMPLOYEE_ID]);
        res.redirect('/update-employee?success=Last name updated successfully');
    } catch (err) {
        res.redirect('/update-employee?error=Error updating last name');
    }
});

// Update SIN
router.post('/sin', async (req, res) => {
    const EMPLOYEE_ID = req.session.user.SIN;
    const { sin } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.employee SET sin = $1 WHERE sin = $2', [sin, EMPLOYEE_ID]);
        res.redirect('/update-employee?success=SIN updated successfully');
    } catch (err) {
        res.redirect('/update-employee?error=Error updating SIN');
    }
});

// Update Role
router.post('/role', async (req, res) => {
    const EMPLOYEE_ID = req.session.user.SIN;
    const { role } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.employee SET employee_role = $1 WHERE sin = $2', [role, EMPLOYEE_ID]);
        res.redirect('/update-employee?success=Role updated successfully');
    } catch (err) {
        res.redirect('/update-employee?error=Error updating role');
    }
});

// Update Location
router.post('/location', async (req, res) => {
    const EMPLOYEE_ID = req.session.user.SIN;
    const { location } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.employee SET works_at = $1 WHERE sin = $2', [location, EMPLOYEE_ID]);
        res.redirect('/update-employee?success=Location updated successfully');
    } catch (err) {
        res.redirect('/update-employee?error=Error updating location');
    }
});

// Update Email
router.post('/email', async (req, res) => {
    const EMPLOYEE_ID = req.session.user.SIN;
    const { email } = req.body;
    try {
        await pool.query('UPDATE ehotelschema.employee SET email = $1 WHERE sin = $2', [email, EMPLOYEE_ID]);
        res.redirect('/update-employee?success=Email updated successfully');
    } catch (err) {
        res.redirect('/update-employee?error=Error updating email');
    }
});

module.exports = router;