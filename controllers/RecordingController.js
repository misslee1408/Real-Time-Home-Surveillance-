const ffmpeg = require('fluent-ffmpeg');
const path = require('path');
const fs = require('fs');

// Ensure the 'footages' directory exists
const footagesDir = path.join(__dirname, '..', 'footages');
if (!fs.existsSync(footagesDir)) {
  fs.mkdirSync(footagesDir);
}

// Global variable to keep track of the current recording process
let recordingProcess = null;
let recordingPath = '';

exports.startRecording = (req, res) => {
  const cameraUrl = req.body.cameraUrl;

  if (!cameraUrl) {
    return res.status(400).send('Camera URL is required');
  }

  const outputFileName = `recording-${new Date().toISOString().replace(/:/g, '-')}.mp4`;
  recordingPath = path.join(footagesDir, outputFileName);

  // Start the ffmpeg recording process
  recordingProcess = ffmpeg(cameraUrl)
    .output(recordingPath)
    .on('start', () => {
      console.log(`Started recording to ${recordingPath}`);
    })
    .on('end', () => {
      console.log(`Recording finished: ${recordingPath}`);
      // Optionally, reset the recording process and path
      recordingProcess = null;
      recordingPath = '';
    })
    .on('error', (err) => {
      console.error(`Recording error: ${err.message}`);
      recordingProcess = null;
      recordingPath = '';
      res.status(500).send(`Recording error: ${err.message}`);
    })
    .run();

  res.status(200).send(`Recording started and saving to ${recordingPath}`);
};

exports.stopRecording = (req, res) => {
  if (recordingProcess) {
     recordingProcess.kill('SIGINT'); // Send SIGINT to stop the recording
    recordingProcess = null;
    res.status(200).send({ message: 'Recording stopped', filePath: recordingPath });
  } else {
    res.status(400).send({ message: 'No recording in progress' });
  }
};
