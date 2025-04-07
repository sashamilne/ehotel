const express = require('express');
const path = require('path');
const pool = require('./db')
const session = require("express-session")
const updateEmployeeRoutes = require('./routes/employee');
const updateClientRoutes = require('./routes/client');
const reservationRoutes = require('./routes/reservation');
const apiRoutes = require('./routes/api');
const flash = require('connect-flash');


const app = express();


// Serve static files from the "public" directory
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true })); // to handle form data
app.use(express.json()); // to handle JSON data
app.use(flash());   // Middleware for flash messages
// Middleware: Setup session before any routes
app.use(session({
    secret: process.env.SESSION_SECRET, // Replace with a strong secret in production
    resave: false, 
    saveUninitialized: false, // Don't save session if it's not modified
    cookie: { secure: false } // For development, use true in production with HTTPS
  }));

  // Set up EJS as the view engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));  // Where your EJS files are located

// add all the routes
app.use('/update-employee', updateEmployeeRoutes);
app.use('/update-client', updateClientRoutes);
app.use('/api', apiRoutes);
app.use('/reservation', reservationRoutes);


app.get('/employee-login', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'employee-login.html'));
  });

app.post('/employee-login', async (req, res) => {
  const {email, sin } = req.body;

  try {
    const result = await pool.query(
      "SELECT * FROM ehotelschema.employee WHERE email = $1",
      [email]
    );

    const user = result.rows[0];
    if (!user) {
      return res.status(401).send('No employee found with that email.');
    }

    // For simplicity, plaintext password comparison (replace with bcrypt in production)
    if (user.sin != sin) {
      return res.status(401).send('Incorrect password.');
    }

    // Store user info in the session
    req.session.user = {
        SIN: user.sin,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: "employee"
      };

    res.redirect('/employee-dashboard');
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

app.get('/employee-dashboard', (req, res) => {
    if (!req.session.user) {
        return res.status(401).send('Please log in first.');
    }
    res.sendFile(path.join(__dirname, 'public', 'employee-dashboard.html'));
  });

  app.get('/client-login', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'client-login.html'));
  });

app.post('/client-login', async (req, res) => {
  const {email, sin } = req.body;

  try {
    const result = await pool.query(
      "SELECT * FROM ehotelschema.client WHERE email = $1",
      [email]
    );

    const user = result.rows[0];
    
    if (!user) {
      return res.status(401).send('No employee found with that email.');
    }

    if (user.sin != sin) {
      return res.status(401).send('Incorrect password.');
    }
    // Store user info in the session
    req.session.user = {
        SIN: user.sin,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: "client"
      };
    
    res.redirect('/client-dashboard');
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
});

app.get('/client-dashboard', (req, res) => {
    if (!req.session.user) {
        return res.status(401).send('Please log in first.');
    }

    res.sendFile(path.join(__dirname, 'public', 'client-dashboard.html'));
  });

  // POST request to handle logout
app.get('/logout', (req, res) => {
    // Destroy the session to log the user out
    req.session.destroy((err) => {
      if (err) {
        return res.status(500).send('Could not log out.');
      }
      // Redirect to login page after logout
      res.redirect('/');
    });
  });

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});