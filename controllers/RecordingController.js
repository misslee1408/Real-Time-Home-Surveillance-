const path = require('path');
const fs = require('fs');
const ffmpeg = require('fluent-ffmpeg');

// Ensure the 'footages' directory exists
const footagesDir = path.join(__dirname, '..', 'footages');
if (!fs.existsSync(footagesDir)) {
  fs.mkdirSync(footagesDir);
}

// Global variables to keep track of the current recording process
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
    .inputOptions([
      '-fflags +genpts', // Generate PTS
      '-analyzeduration 10000000', // Analyze duration to get accurate timestamps
      '-probesize 10000000', // Probe size for accurate stream data
      '-rtbufsize 1500M' // Increase buffer size
    ])
    .outputOptions([
      '-c:v libx264', // Use H.264 codec
      '-preset ultrafast', // Fastest encoding preset
      '-crf 0', // Lossless quality
      '-f mp4' // Explicitly specify the format
    ])
    .output(recordingPath)
    .on('start', (commandLine) => {
      console.log(`Started recording with command: ${commandLine}`);
    })
    .on('end', () => {
      console.log(`Recording finished: ${recordingPath}`);
      recordingInProgress = false;
    })
    .on('error', (err, stdout, stderr) => {
      console.error(`Recording error: ${err.message}`);
      console.error(`FFmpeg stdout: ${stdout}`);
      console.error(`FFmpeg stderr: ${stderr}`);
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

    // Add a delay to ensure the process has stopped before sending a response
    setTimeout(() => {
      if (!res.headersSent) {
        res.status(200).send({ message: 'Recording stopped', filePath: recordingPath });
      }
    }, 2000); // Adjust timeout as needed
  } else {
    if (!res.headersSent) {
      res.status(400).send({ message: 'No recording in progress' });
    }
  }

  recordingInProgress = false;
};
