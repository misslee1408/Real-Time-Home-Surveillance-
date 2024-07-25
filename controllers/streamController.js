// controllers/streamController.js

const ffmpeg = require('fluent-ffmpeg');

// Replace with the actual URL of your camera stream
const cameraStreamUrl = 'http://username:password@41.70.47.48:8556/';

const streamVideo = (req, res) => {
  try {
    res.contentType('video/webm');

    const ffmpegCommand = ffmpeg(cameraStreamUrl)
      .format('webm')
      .videoCodec('libvpx')
      .audioCodec('libopus')
      .on('start', () => {
        console.log('Stream started');
      })
      .on('end', () => {
        console.log('Stream ended');
      })
      .on('error', (err) => {
        console.error('Error:', err);
        if (!res.headersSent) {
          res.status(500).send('Error streaming video');
        }
      })
      .on('stderr', (stderrLine) => {
        console.error('FFmpeg stderr:', stderrLine);
      });

    ffmpegCommand.pipe(res, { end: true });

  } catch (error) {
    console.error('Stream error:', error);
    if (!res.headersSent) {
      res.status(500).send('Internal server error');
    }
  }
};

module.exports = {
  streamVideo,
};
