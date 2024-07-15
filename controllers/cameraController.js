const { Camera } = require('../models');
const Nexmo = require('nexmo');
// adding something new flonicah
const { spawn } = require('child_process');
const path = require('path');

// vonage ai integration fot the sms receiving #flonicah

// const nexmo = new Nexmo({
//   apiKey: '19690ed4', //vonage api api key
//   apiSecret: 'vPp4uzxTaX9cuHlB' //vonage api secrt key
// });
// trying to use the vonage fomat to get rid of the uotdated 

const { Vonage } = require('@vonage/server-sdk')

const vonage = new Vonage({
  apiKey: "19690ed4",
  apiSecret: "vPp4uzxTaX9cuHlB"
})


// adding the contact to  recieve the smsflonicah
const vonagePhoneNumber = 'Vonage APIs';
const recipientPhoneNumber = '265997189926';

// Fetch all cameras
exports.getAllCameras = async (req, res) => {
  try {
    const cameras = await Camera.findAll();
    res.json(cameras);
  } catch (error) {
    res.status(500).json({ error: 'oops!! Failed to fetch all cameras' });
  }
};

// Add a new camera
exports.addCamera = async (req, res) => {
  try {
    const camera = await Camera.create(req.body);
    res.status(201).json(camera);
  } catch (error) {
    res.status(500).json({ error: 'oops! Failed to add camera' });
  }
};

// Fetch a single camera by its ID
exports.getCameraById = async (req, res) => {
  try {
    const camera = await Camera.findByPk(req.params.id);
    if (camera) {
      res.json(camera);
    } else {
      res.status(404).json({ error: 'oh oh! Camera not found' });
    }
  } catch (error) {
    res.status(500).json({ error: 'oops Failed to fetch camera' });
  }
};

// Delete a camera by its ID
exports.deleteCamera = async (req, res) => {
  try {
    const deleted = await Camera.destroy({
      where: { id: req.params.id }
    });
    if (deleted) {
      res.status(204).json();
    } else {
      res.status(404).json({ error: 'oh oh Camera not found' });
    }
  } catch (error) {
    res.status(500).json({ error: 'oops! Failed to delete camera' });
  }
};

// Send SMS on motion detection #flonicah
exports.sendSmsOnMotionDetection = async (cameraId) => {
  try {
    const camera = await Camera.findByPk(cameraId);
    if (camera) {
      const message = `Motion detected by camera ${camera.name} at location ${camera.location}`;
      nexmo.message.sendSms(vonagePhoneNumber, recipientPhoneNumber, message, (err, responseData) => {
        if (err) {
          console.log('Error sending SMS:', err);
        } else {
          if (responseData.messages[0].status === '0') {
            console.log('SMS sent successfully:', responseData);
          } else {
            console.log(`SMS failed with status: ${responseData.messages[0]['status']}`);
          }
        }
      });
    } else {
      console.log('Camera not found for motion detection.');
    }
  } catch (error) {
    console.error('Error sending SMS on motion detection:', error);
  }
};
// starting video recording for the cammera #flonicah
exports.startVideoRecording = async (cameraId) => {
  try {
    const camera = await Camera.findByPk(cameraId);
    if (camera) {
      const filePath = path.join(__dirname, '..', 'recordings', `camera_${cameraId}_${Date.now()}.mp4`);
      const cameraUrl = 'rtsp://our-camera-url'; // sensor camera's RTSP stream URL(dummy for a moment) # FLONICAH

      // Example using ffmpeg for video recording# FLONICAH
      const ffmpegProcess = spawn('ffmpeg', [
        '-i', cameraUrl,
        '-t', '3600', // Recording duration (in seconds)FLONICAH
        '-codec:v', 'copy',
        '-an', filePath
      ]);

      ffmpegProcess.stdout.on('data', (data) => {
        console.log(`stdout: ${data}`);
      });

      ffmpegProcess.stderr.on('data', (data) => {
        console.error(`stderr: ${data}`);
      });

      ffmpegProcess.on('close', (code) => {
        console.log(`Video recording finished with code ${code}`);
      });
    } else {
      console.log('Camera not found for video recording.');
    }
  } catch (error) {
    console.error('Error starting video recording:', error);
  }
};
