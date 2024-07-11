const WebSocket = require('ws');

//The WebSocket server listens for connections on port 8080.
const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    
    // Broadcast incoming message to all connected clients
    /*It broadcasts any incoming messages to all connected clients.
     This is crucial for WebRTC signaling (exchanging offers, answers, and ICE candidates).*/
    wss.clients.forEach(function each(client) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
  });

  //When a client connects, it sends a welcome message.
  ws.send('Welcome to the WebSocket server!');
});

console.log('WebSocket server is running on ws://localhost:8080');
