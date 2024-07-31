const express = require('express');
const router = express.Router();
const footageController = require('../controllers/footageController');

// Define the route for fetching a specific footage
router.get('/footages/:filename', footageController.getFootage);
router.get('/footages', footageController.listFootages);

module.exports = router;