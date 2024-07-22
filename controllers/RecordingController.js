const { spawn } = require('child_process');
const path = require('path');
const { Camera } = require('../models');

// Full path to ffmpeg executable
const ffmpegPath = path.join('C:', 'ffmpeg-7.0.1-essentials_build', 'bin', 'ffmpeg.exe');

let ffmpegProcesses = {};

exports.startRecording = async (req, res) => {
  const { cameraId } = req.body;
  try {
    const camera = await Camera.findByPk(cameraId);
    if (!camera) {
      return res.status(404).json({ error: 'Camera not found' });
    }

    const streamurl = camera.streamurl;
    if (!streamurl) {
      return res.status(400).json({ error: 'Camera stream URL is not defined' });
    }

    console.log(`Starting recording for camera ${cameraId} with stream URL: ${streamurl}`);
    
    const outputPath = path.join(__dirname, '..', 'footages', `camera_${cameraId}_recording.mp4`);
    const ffmpegArgs = ['-i', streamurl, '-t', '60', '-c', 'copy', outputPath];
    
    ffmpegProcesses[cameraId] = spawn(ffmpegPath, ffmpegArgs);

    ffmpegProcesses[cameraId].on('close', (code) => {
      console.log(`ffmpeg process for camera ${cameraId} exited with code ${code}`);
      delete ffmpegProcesses[cameraId];
    });

    ffmpegProcesses[cameraId].stderr.on('data', (data) => {
      console.error(`stderr for camera ${cameraId}: ${data}`);
    });

    res.status(200).json({ message: 'Recording started', outputPath });
  } catch (error) {
    console.error('Error starting recording:', error);
    res.status(500).json({ error: 'Failed to start recording' });
  }
};

exports.stopRecording = (req, res) => {
  const { cameraId } = req.body;
  try {
    const ffmpegProcess = ffmpegProcesses[cameraId];
    if (ffmpegProcess) {
      // Send SIGINT first to gracefully stop recording
      ffmpegProcess.kill('SIGINT');

      // Add a delay to allow FFMPEG to handle the signal and finish writing the file
      setTimeout(() => {
        if (ffmpegProcesses[cameraId]) {
          // If still running, forcefully kill it
          ffmpegProcesses[cameraId].kill('SIGKILL');
          console.log(`Forcefully killed ffmpeg process for camera ${cameraId}`);
        }
        delete ffmpegProcesses[cameraId];
      }, 5000); // 5 seconds delay

      res.status(200).json({ message: 'Recording stopped' });
    } else {
      console.log(`No recording process found for camera ${cameraId}`);
      res.status(400).json({ error: 'No recording process to stop' });
    }
  } catch (error) {
    console.error('Error stopping recording:', error);
    res.status(500).json({ error: 'Failed to stop recording' });
  }
};
