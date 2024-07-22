const { Camera } = require('../models');

// Fetch all cameras
exports.getAllCameras = async (req, res) => {
  try {
    const cameras = await Camera.findAll();
    res.json(cameras);
  } catch (error) {
    console.error('Error fetching cameras:', error.message);
    res.status(500).json({ error: 'Failed to fetch cameras' });
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
