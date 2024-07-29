const express = require('express');
const router = express.Router();
const footageController = require('../controllers/footageController');

// Define the route for fetching a specific footage
router.get('/footages/:filename', footageController.getFootage);

module.exports = router;