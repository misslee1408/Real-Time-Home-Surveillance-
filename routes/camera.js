//This file sets up routes for handling HTTP requests related to cameras.

const express = require('express');
const router = express.Router();

//the camera routes need the camera controller
const cameraController = require('../controllers/cameraController');


//router.get('/')this handles GET requests to fetch all cameras.
router.get('/', cameraController.getAllCameras);

//router.post('/') this handles POST requests to add a new camera.
router.post('/', cameraController.addCamera);

//router.get('/:id') this handles GET requests to fetch a camera by its ID.
router.get('/:id', cameraController.getCameraById);

//router.put('/:id') handles PUT requests to update a camera by its ID.
router.put('/:id', cameraController.updateCamera);

//router.delete('/:id') handles DELETE requests to remove a camera by its ID.
router.delete('/:id', cameraController.deleteCamera);

module.exports = router;
