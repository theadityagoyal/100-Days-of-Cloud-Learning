function createWS() {
    const proto = location.protocol === 'https:' ? 'wss' : 'ws';
    const host = location.host; // automatically ngrok ya localhost pick karega
    return new WebSocket(`${proto}://${host}`);
}
