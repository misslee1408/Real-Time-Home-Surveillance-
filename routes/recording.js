// routes/recording.js
const express = require('express');
const router = express.Router();
const recordingController = require('../controllers/RecordingController');

router.post('/start', recordingController.startRecording);
router.post('/stop', recordingController.stopRecording);

module.exports = router;
