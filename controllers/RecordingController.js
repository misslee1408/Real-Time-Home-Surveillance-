const path = require('path');
const fs = require('fs');
const ffmpeg = require('fluent-ffmpeg');

// Ensure the 'footages' directory exists
const footagesDir = path.join(__dirname, '..', 'footages');
if (!fs.existsSync(footagesDir)) {
  fs.mkdirSync(footagesDir);
}

// Global variable to keep track of the current recording process
let recordingProcess = null;
let recordingPath = '';
let recordingInProgress = false;

exports.startRecording = (req, res) => {
  const cameraUrl = req.body.cameraUrl;

  if (!cameraUrl) {
    return res.status(400).send('Camera URL is required');
  }

  if (recordingInProgress) {
    return res.status(400).send('Recording already in progress');
  }

  const outputFileName = `recording-${new Date().toISOString().replace(/:/g, '-')}.mp4`;
  recordingPath = path.join(footagesDir, outputFileName);

  recordingInProgress = true;

  recordingProcess = ffmpeg(cameraUrl)
    .output(recordingPath)
    .on('start', () => {
      console.log(`Started recording to ${recordingPath}`);
    })
    .on('end', () => {
      console.log(`Recording finished: ${recordingPath}`);
      recordingInProgress = false;
    })
    .on('error', (err) => {
      console.error(`Recording error: ${err.message}`);
      recordingInProgress = false;
      if (!res.headersSent) {
        res.status(500).send(`Recording error: ${err.message}`);
      }
    })
    .run();

  if (!res.headersSent) {
    res.status(200).send(`Recording started and saving to ${recordingPath}`);
  }
};

exports.stopRecording = (req, res) => {
  if (recordingProcess) {
    recordingProcess.kill('SIGINT'); // Send SIGINT to stop the recording
    recordingProcess = null;
    recordingInProgress = false;

    // Add a delay to ensure the process has stopped before sending a response
    setTimeout(() => {
      if (!res.headersSent) {
        res.status(200).send({ message: 'Recording stopped', filePath: recordingPath });
      }
    }, 1000); // Adjust timeout as needed
  } else {
    if (!res.headersSent) {
      res.status(400).send({ message: 'No recording in progress' });
    }
  }
};
