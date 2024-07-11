const express = require('express');
const app = express();
const cameraRoutes = require('./routes/camera');
const WebSocket = require('ws');
const path = require('path');

app.use(express.json());
app.use('/api/cameras', cameraRoutes);

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

const PORT = process.env.PORT || 3000;

// Start the Express server first
const server = app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

// Now create the WebSocket server
const wss = new WebSocket.Server({ server });

wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    try {
      const data = JSON.parse(message);

      switch (data.type) {
        case 'offer':
        case 'answer':
        case 'iceCandidate':
          // Broadcast signaling data to all connected clients except the sender
          wss.clients.forEach(function each(client) {
            if (client !== ws && client.readyState === WebSocket.OPEN) {
              client.send(JSON.stringify(data));
            }
          });
          break;
        default:
          console.log('Unknown message type:', data.type);
      }
    } catch (error) {
      console.error('Error processing message:', error);
    }
  });

  ws.on('error', (error) => {
    console.error('WebSocket error:', error);
  });

  ws.send(JSON.stringify({ message: 'Welcome to the WebSocket server!' }));
});

console.log('WebSocket server is running on ws://localhost:' + PORT);
