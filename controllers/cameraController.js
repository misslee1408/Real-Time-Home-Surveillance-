const { Camera } = require('../models');
const Nexmo = require('nexmo');

const nexmo = new Nexmo({
  apiKey: 'YOUR_API_KEY', //vonage api api key
  apiSecret: 'YOUR_API_SECRET' //vonage api secrt key
});

const vonagePhoneNumber = 'Vonage APIs';
const recipientPhoneNumber = 'YOUR_PHONE_NUMBER';

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

// Send SMS on motion detection
// exports.sendSmsOnMotionDetection = async (cameraId) => {
//   try {
//     const camera = await Camera.findByPk(cameraId);
//     if (camera) {
//       const message = `Motion detected by camera ${camera.name} at location ${camera.location}`;
//       nexmo.message.sendSms(vonagePhoneNumber, recipientPhoneNumber, message, (err, responseData) => {
//         if (err) {
//           console.log('Error sending SMS:', err);
//         } else {
//           if (responseData.messages[0].status === '0') {
//             console.log('SMS sent successfully:', responseData);
//           } else {
//             console.log(`SMS failed with status: ${responseData.messages[0]['status']}`);
//           }
//         }
//       });
    } else {
      console.log('Camera not found for motion detection.');
    }
  } catch (error) {
    console.error('Error sending SMS on motion detection:', error);
  }
};
