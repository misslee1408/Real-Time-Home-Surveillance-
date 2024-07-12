<<<<<<< HEAD
// app.js
const express = require('express');
const path = require('path');
const { Server } = require('ws');
const { spawn } = require('child_process');
const app = express();
const port = process.env.PORT || 3000;
const cameraRoutes = require('./routes/camera')
const userRoutes = require('./routes/user');

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

// User routes
app.use('/api/users', userRoutes);
//camera routes
app.use('/api/cameras', cameraRoutes);
=======
const express = require('express');
const { Server } = require('ws');
const { spawn } = require('child_process');
const path = require('path');
const cameraRoutes = require('./routes/camera');
const app = express();
const port = process.env.PORT || 3000;

app.use('/api/cameras', cameraRoutes);  // Use the camera routes
// Static file serving
app.use(express.static(path.join(__dirname, 'public')));
>>>>>>> cd4b515ecd7eb5faacbcdffbd4574e776db1719a

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
<<<<<<< HEAD
=======

>>>>>>> cd4b515ecd7eb5faacbcdffbd4574e776db1719a
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
<<<<<<< HEAD
});
=======
});
>>>>>>> cd4b515ecd7eb5faacbcdffbd4574e776db1719a
