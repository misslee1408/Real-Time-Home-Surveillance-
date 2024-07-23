const express = require('express');
const { addCamera, getCameras, getCameraById, deleteCamera } = require('../controllers/cameraController');

const router = express.Router();

router.post('/add', addCamera);
router.get('/', getCameras);
router.get('/:id', getCameraById);
router.delete('/:id', deleteCamera);

module.exports = router;
