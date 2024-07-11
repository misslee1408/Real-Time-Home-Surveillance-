const express = require('express');
const { Server } = require('ws');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Static file serving
app.use(express.static(path.join(__dirname, 'public')));

// Endpoint for video stream
app.post('/stream', (req, res) => {
    const ffmpeg = spawn('ffmpeg', [
        '-i', '-', // Input from stdin
        '-vcodec', 'copy', // Video codec
        '-acodec', 'copy', // Audio codec
        '-f', 'mpegts', // Output format
        'udp://127.0.0.1:1234' // Output to local UDP port
    ]);

    req.pipe(ffmpeg.stdin);

    ffmpeg.stderr.on('data', (data) => {
        console.log(`FFmpeg stderr: ${data}`);
    });

    ffmpeg.on('close', (code) => {
        console.log(`FFmpeg process exited with code ${code}`);
        res.sendStatus(200);
    });
});

// WebSocket server setup
const server = app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});

const wss = new Server({ server });

wss.on('connection', (ws) => {
    ws.on('message', (message) => {
        const data = JSON.parse(message);

        if (data.offer) {
            // Handle offer
        } else if (data.answer) {
            // Handle answer
        } else if (data.iceCandidate) {
            // Handle ICE candidate
        }

        // Broadcast the message to all clients except the sender
        wss.clients.forEach((client) => {
            if (client !== ws && client.readyState === WebSocket.OPEN) {
                client.send(message);
            }
        });
    });

    ws.send(JSON.stringify({ message: 'WebSocket connection established' }));
});
