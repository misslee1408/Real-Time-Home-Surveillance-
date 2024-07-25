// routes/streamRoutes.js

const express = require('express');
const router = express.Router();
const { streamVideo } = require('../controllers/streamController');

// Define the route for streaming video
router.get('/stream', streamVideo);

module.exports = router;

