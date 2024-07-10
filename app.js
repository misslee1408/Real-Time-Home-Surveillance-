/* This is the main application file */

const express = require('express');
const app = express();

//Integratimg the camera route in the main application
const cameraRoutes = require('./routes/camera');

//this middleware parses incoming JSON requests.
app.use(express.json());

//this sets up the camera routes under the /api/cameras path.
app.use('/api/cameras', cameraRoutes);

//The application listens on the specified port (default is 3000).
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${3000}`);
});
