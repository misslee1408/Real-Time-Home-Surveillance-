const { Camera } = require('../models');

exports.addCamera = async (req, res) => {
  try {
    const { name, location, streamurl, isActive } = req.body;
    const newCamera = await Camera.create({ name, location, streamurl, isActive });
    res.status(201).json(newCamera);
  } catch (error) {
    console.error('Error adding camera:', error);
    res.status(500).json({ error: 'Failed to add camera' });
  }
};

exports.getCameras = async (req, res) => {
  try {
    const cameras = await Camera.findAll();
    res.status(200).json(cameras);
  } catch (error) {
    console.error('Error fetching cameras:', error);
    res.status(500).json({ error: 'Failed to retrieve cameras' });
  }
};

exports.getCameraById = async (req, res) => {
  try {
    const { id } = req.params;
    const camera = await Camera.findByPk(id);
    if (camera) {
      res.status(200).json(camera);
    } else {
      res.status(404).json({ error: 'Camera not found' });
    }
  } catch (error) {
    console.error('Error retrieving camera:', error);
    res.status(500).json({ error: 'Failed to retrieve camera' });
  }
};

exports.deleteCamera = async (req, res) => {
  try {
    const { id } = req.params;
    const deleted = await Camera.destroy({ where: { id } });
    if (deleted) {
      res.status(204).json();
    } else {
      res.status(404).json({ error: 'Camera not found' });
    }
  } catch (error) {
    console.error('Error deleting camera:', error);
    res.status(500).json({ error: 'Failed to delete camera' });
  }
};
