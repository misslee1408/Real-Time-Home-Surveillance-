const WebSocket = require('ws');
const wss = new WebSocket.Server({ server });

wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    console.log('Received message:', message);
    // Handle signaling messages (offer, answer, ICE candidates)
  });

  ws.send('WebSocket server connected'); // Send a message to client upon connection
});


console.log('WebSocket server is running on ws://localhost:8080');
