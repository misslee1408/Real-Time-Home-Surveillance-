// app.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path');
const { sequelize } = require('./models');
const app = express();
const port = process.env.PORT || 3000;
const cameraController = require('./controllers/cameraController');
const fs = require('fs');
const session = require('express-session');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
dotenv.config();



// Serve HLS content
const hlsDir = path.join(__dirname, 'hls');
if (!fs.existsSync(hlsDir)) {
  fs.mkdirSync(hlsDir);
}
const Nexmo = require('nexmo');


// Middleware to parse JSON and urlencoded data
const allowedOrigins = ['http://localhost:50615'];

app.use(cors({
    origin: function(origin, callback) {
        if (!origin || allowedOrigins.indexOf(origin) !== -1) {
            callback(null, true);
        } else {
            callback(new Error('Not allowed by CORS'));
        }
    }
}));


app.use(cookieParser());
app.use(session({
  secret: process.env.SESSION_SECRET, // Use the environment variable for the secret
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Set to true if using HTTPS
}));

app.use(session({
  secret: process.env.SESSION_SECRET, // Use the environment variable for the secret
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Set to true if using HTTPS
}));

app.use(bodyParser.json());

// Serve static files from the "public" directory
app.use(express.static(path.join(__dirname, 'public')));

// Import and use camera routes
const cameraRoutes = require('./routes/camera');
app.use('/api/cameras', cameraRoutes);

// Import and use user routes
const userRoutes = require('./routes/user');
app.use('/api/users', userRoutes);

// Import and use recording routes
const recordingRoutes = require('./routes/recording');
app.use('/api/recording', recordingRoutes);

//import and use stream routes
const streamRouter = require('./routes/stream');
app.use('/hls', express.static(hlsDir));
app.use('/api', streamRouter);


const footageRoutes = require('./routes/footage');
app.use('/api', footageRoutes);

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
    if (data.command === 'startVideoRecording' && data.cameraId) {
      cameraController.startVideoRecording(data.cameraId);
    } else if (data.cameraId) {
      cameraController.sendSmsOnMotionDetection(data.cameraId);
    }
  });

  ws.send('WebSocket server connected'); // Send a message to client upon connection
});

console.log('WebSocket server is running on ws://localhost:8080');




// const express = require('express');
// const bodyParser = require('body-parser');
// const cors = require('cors');
// const path = require('path');
// const { sequelize } = require('./models');
// const app = express();
// const port = process.env.PORT || 3000;
// const Nexmo = require('nexmo');
// const cameraController = require('./controllers/cameraController');


// // Middleware to parse JSON and urlencoded data
// app.use(cors());
// app.use(bodyParser.json());


// // Serve static files from the "public" directory
// app.use(express.static(path.join(__dirname, 'public')));

// //import and use stream routes
// const streamRoutes = require('./routes/stream');
// app.use('/api/stream/', streamRoutes);

// // Import and use camera routes
// const cameraRoutes = require('./routes/camera');
// app.use('/api/cameras', cameraRoutes);

// // Import and use user routes
// const userRoutes = require('./routes/user');
// app.use('/api/users', userRoutes);

// //import and use the recording routes
// const recordingRoutes = require('./routes/recording');
// app.use('/api/recording', recordingRoutes);

// // // Import and use motion detection routes
// // const motionRoutes = require('./routes/motion');
// // app.use('/api/motion', motionRoutes);

// // Test database connection
// sequelize.authenticate()
//   .then(() => {
//     console.log('Connection to the database has been established successfully.');
//   })
//   .catch(err => {
//     console.error('Unable to connect to the database:', err);
//   });

// // Sync database
// sequelize.sync()
//   .then(() => {
//     console.log('Database synced successfully');
//   })
//   .catch(err => {
//     console.error('Error syncing database:', err);
//   });

// // Set up WebSocket server
// const server = app.listen(port, () => {
//   console.log(`Server is running on port ${port}`);
// });
// const WebSocket = require('ws');
// const wss = new WebSocket.Server({ server });

// wss.on('connection', function connection(ws) {
//   ws.on('message', function incoming(message) {
//     const data = JSON.parse(message);
//     if (data.command === 'startVideoRecording' && data.cameraId) {
//       cameraController.startVideoRecording(data.cameraId);
//     } else if (data.cameraId) {
//       cameraController.sendSmsOnMotionDetection(data.cameraId);
//     }
//   });

//   ws.send('WebSocket server connected'); // Send a message to client upon connection
// });

// console.log('WebSocket server is running on ws://localhost:8080');