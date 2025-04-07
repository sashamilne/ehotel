const express = require('express');
const path = require('path');
const pool = require('./db');
const session = require("express-session");
const flash = require('connect-flash');

// Import routes
const updateEmployeeRoutes = require('./routes/employee');
const updateClientRoutes = require('./routes/client');
const reservationRoutes = require('./routes/reservation');
const apiRoutes = require('./routes/api');

const app = express();

// Middleware setup
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(flash());

app.use(session({
  secret: process.env.SESSION_SECRET || 'secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: { secure: false } // Set true only in production with HTTPS
}));

// View engine setup (for potential future use with EJS)
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Routes
app.use('/update-employee', updateEmployeeRoutes);
app.use('/update-client', updateClientRoutes);
app.use('/api', apiRoutes);
app.use('/reservation', reservationRoutes);

// Employee Sign Up
app.get('/employee-signup', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'employee-signup.html'));
});

app.post('/employee-signup', async (req, res) => {
  const { sin, first_name, last_name, email } = req.body;
  try {
    await pool.query(
      `INSERT INTO ehotelschema.employee (sin, first_name, last_name, email, employee_role, works_at, phone_number) 
       VALUES ($1, $2, $3, $4, $5, $6, $7)`,
      [
        sin,
        first_name,
        last_name,
        email,
        'staff', // default role
        1,       // placeholder hotel_id
        '000-000-0000'
      ]
    );
    res.redirect('/employee-login');
  } catch (err) {
    console.error(err);
    res.status(500).send('Employee sign-up failed.');
  }
});


// Client Sign Up
app.get('/client-signup', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'client-signup.html'));
});

app.post('/client-signup', async (req, res) => {
  const { sin, first_name, last_name, email } = req.body;
  try {
    await pool.query(
      `INSERT INTO ehotelschema.client (sin, first_name, last_name, email, registration_date, phone_number) 
       VALUES ($1, $2, $3, $4, $5, $6)`,
      [sin, first_name, last_name, email, new Date(), "000-000-0000"]
    );
    
    res.redirect('/client-login');
  } catch (err) {
    console.error(err);
    res.status(500).send('Client sign-up failed.');
  }
});


// Employee Login
app.get('/employee-login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'employee-login.html'));
});

app.post('/employee-login', async (req, res) => {
  const { email, sin } = req.body;

  try {
    const result = await pool.query(
      "SELECT * FROM ehotelschema.employee WHERE email = $1",
      [email]
    );

    const user = result.rows[0];
    if (!user) {
      return res.status(401).send('No employee found with that email.');
    }

    if (user.sin != sin) {
      return res.status(401).send('Incorrect SIN.');
    }

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
  if (!req.session.user || req.session.user.role !== 'employee') {
    return res.status(401).send('Please log in as an employee.');
  }
  res.sendFile(path.join(__dirname, 'public', 'employee-dashboard.html'));
});

// Client Login
app.get('/client-login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'client-login.html'));
});

app.post('/client-login', async (req, res) => {
  const { email, sin } = req.body;

  try {
    const result = await pool.query(
      "SELECT * FROM ehotelschema.client WHERE email = $1",
      [email]
    );

    const user = result.rows[0];

    if (!user) {
      return res.status(401).send('No client found with that email.');
    }

    if (user.sin != sin) {
      return res.status(401).send('Incorrect SIN.');
    }

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
  if (!req.session.user || req.session.user.role !== 'client') {
    return res.status(401).send('Please log in as a client.');
  }
  res.sendFile(path.join(__dirname, 'public', 'client-dashboard.html'));
});

// Logout
app.get('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).send('Could not log out.');
    }
    res.redirect('/');
  });
});

// Home Route
app.get('/', (req, res) => {
  res.send('<h1>Welcome to eHotel</h1><p><a href="/employee-login">Employee Login</a> | <a href="/client-login">Client Login</a></p>');
});

// Server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
