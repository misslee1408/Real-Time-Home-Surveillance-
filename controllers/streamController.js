const ffmpeg = require('fluent-ffmpeg');

// URL of your camera stream
const cameraStreamUrl = 'rtsp://41.70.47.48/:544/Streaming/channels/101';

const streamVideo = (req, res) => {
  try {
    const ffmpegCommand = ffmpeg(cameraStreamUrl)
      .inputOptions([
        '-rtsp_transport', 'tcp',        // Use TCP for RTSP transport
        '-analyzeduration', '1000000',   // Increase analyzeduration
        '-probesize', '5000000'          // Increase probesize
      ])
      .outputOptions([
        '-preset', 'ultrafast',          // Use ultrafast preset for minimal latency
        '-crf', '18',                    // Constant Rate Factor (lower is better quality)
        '-bufsize', '300000k',           // Set buffer size (300 MB, adjust as needed)
        '-maxrate', '10000k',            // Maximum bitrate for the stream
        '-b:v', '8000k',                 // Set video bitrate
        '-g', '50'                       // Set group of pictures (GOP) size
      ])
      .format('webm')                    // Use webm for streaming
      .videoCodec('libvpx')              // Use libvpx for video codec
      .audioCodec('libvorbis')           // Use libvorbis for audio codec
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

    res.contentType('video/webm');
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
