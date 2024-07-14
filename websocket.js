const express = require('express');
const path = require('path');
const { sequelize } = require('./models');
const cameraController = require('./controllers/cameraController');

const app = express();
const port = process.env.PORT || 3000;

// Middleware to parse JSON and urlencoded data
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files from the "public" directory
app.use(express.static(path.join(__dirname, 'public')));

const cameraRoutes = require('./routes/camera');
app.use('/api/cameras', cameraRoutes);

// Import and use user routes
const userRoutes = require('./routes/user');
app.use('/api/users', userRoutes);

// Test database connection
sequelize.authenticate()
  .then(() => {
    console.log('Connection to the database has been established successfully.');
  })
  .catch(err => {
    console.error('Unable to connect to the database:', err);
  });

// Sync database
sequelize.sync()
  .then(() => {
    console.log('Database synced successfully');
  })
  .catch(err => {
    console.error('Error syncing database:', err);
  });

// Set up WebSocket server
const server = app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

const WebSocket = require('ws');
const wss = new WebSocket.Server({ server });

wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    const data = JSON.parse(message);
    if (data.cameraId) {
      cameraController.sendSmsOnMotionDetection(data.cameraId);
    }
  });

  ws.send('WebSocket server connected'); // Send a message to client upon connection
});

console.log('WebSocket server is running on ws://localhost:8080');
