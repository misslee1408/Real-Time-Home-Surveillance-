const express = require('express');
const {
  getAllCameras,
  addCamera,
  getCameraById,
  deleteCamera
} = require('../controllers/cameraController');

const router = express.Router();

router.get('/', getAllCameras);
router.post('/', addCamera);
router.get('/:id', getCameraById);
router.delete('/:id', deleteCamera);

module.exports = router;
