// server.js
const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const { v4: uuidv4 } = require('uuid');
const path = require('path');
const cors = require('cors');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// In-memory rooms: { roomId: { token, sharer: ws|null, viewers: Set<ws> } }
const rooms = {};

/**
 * API: Create new room
 */
app.post('/api/new-room', (req, res) => {
  const roomId = Math.random().toString(36).slice(2, 8);
  const token = Math.random().toString(36).slice(2, 10);
  
  rooms[roomId] = { token, sharer: null, viewers: new Set() };
  
  console.log(`✅ Room created: ${roomId} | Token: ${token}`);
  res.json({ roomId, token });
});

/**
 * API: Get room info (no token)
 */
app.get('/api/room/:roomId', (req, res) => {
  const room = rooms[req.params.roomId];
  if (!room) return res.status(404).json({ error: 'Room not found' });
  res.json({ roomId: req.params.roomId });
});

/**
 * WebSocket Handling
 */
wss.on('connection', (ws) => {
  ws.on('message', (msg) => {
    let data;
    try {
      data = JSON.parse(msg);
    } catch (e) {
      console.warn("⚠ Invalid message received");
      return;
    }

    // Handle joining
    if (data.type === 'join') {
      const { role, roomId, token } = data;
      const room = rooms[roomId];
      if (!room) {
        ws.send(JSON.stringify({ type: 'err', message: 'Room not found' }));
        ws.close();
        return;
      }

      if (role === 'sharer') {
        if (token !== room.token) {
          ws.send(JSON.stringify({ type: 'err', message: 'Invalid token' }));
          ws.close();
          return;
        }
        room.sharer = ws;
        ws.roomId = roomId;
        ws.role = 'sharer';
        console.log(`📡 Sharer joined room: ${roomId}`);
        ws.send(JSON.stringify({ type: 'joined', role: 'sharer', roomId }));
        return;
      }

      if (role === 'viewer') {
        room.viewers.add(ws);
        ws.roomId = roomId;
        ws.role = 'viewer';
        ws.send(JSON.stringify({ type: 'joined', role: 'viewer', roomId }));
        console.log(`👀 Viewer joined room: ${roomId} (Total viewers: ${room.viewers.size})`);
        return;
      }
    }

    // Handle keystroke from sharer
    if (data.type === 'keystroke') {
      const roomId = ws.roomId;
      if (!roomId) return;

      const room = rooms[roomId];
      const payload = JSON.stringify({ type: 'live-keystroke', payload: data });

      room.viewers.forEach(viewerWs => {
        if (viewerWs.readyState === WebSocket.OPEN) {
          viewerWs.send(payload);
        }
      });

      const u = data.username || 'anon';
      console.log(`⌨ [${roomId}] ${u}: ${data.key}`);
    }

    // Handle viewer request for stats
    if (data.type === 'request-stats') {
      const room = rooms[ws.roomId];
      if (!room) return;
      ws.send(JSON.stringify({ type: 'stats', viewers: room.viewers.size }));
    }
  });

  // Handle disconnect
  ws.on('close', () => {
    const roomId = ws.roomId;
    if (!roomId) return;

    const room = rooms[roomId];
    if (!room) return;

    if (ws.role === 'viewer') {
      room.viewers.delete(ws);
    } else if (ws.role === 'sharer') {
      room.sharer = null;
      const payload = JSON.stringify({ type: 'sharer-left' });
      room.viewers.forEach(v => {
        if (v.readyState === WebSocket.OPEN) v.send(payload);
      });
    }

    console.log(`❌ Socket closed from room: ${roomId}`);
  });
});

/**
 * Start Server
 */
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => console.log(`🚀 Server running at http://localhost:${PORT}`));
