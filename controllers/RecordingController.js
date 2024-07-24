const ffmpeg = require('fluent-ffmpeg');
const path = require('path');
const fs = require('fs');

// Ensure the 'footages' directory exists
const footagesDir = path.join(__dirname, '..', 'footages');
if (!fs.existsSync(footagesDir)) {
  fs.mkdirSync(footagesDir);
}

exports.startRecording = (req, res) => {
  const cameraUrl = req.body.cameraUrl;

  if (!cameraUrl) {
    return res.status(400).send('Camera URL is required');
  }

  const outputFileName = `recording-${new Date().toISOString().replace(/:/g, '-')}.mp4`;
  const outputPath = path.join(footagesDir, outputFileName);

  ffmpeg(cameraUrl)
    .output(outputPath)
    .on('start', () => {
      console.log(`Started recording to ${outputPath}`);
    })
    .on('end', () => {
      console.log(`Recording finished: ${outputPath}`);
      res.status(200).send(`Recording saved to ${outputPath}`);
    })
    .on('error', (err) => {
      console.error(`Recording error: ${err.message}`);
      res.status(500).send(`Recording error: ${err.message}`);
    })
    .run();
};


exports.stopRecording = (req, res) => {
  if (recordingProcess) {
    recordingProcess.kill('SIGINT');
    recordingProcess = null;
    res.status(200).send({ message: 'Recording stopped', filePath: recordingPath });
  } else {
    res.status(400).send({ message: 'No recording in progress' });
  }
};