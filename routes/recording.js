const express = require('express');
const router = express.Router();
const recordingController = require('../controllers/RecordingController');

router.post('/start-recording', recordingController.startRecording);
router.post('/stop-recording', recordingController.stopRecording);

module.exports = router;