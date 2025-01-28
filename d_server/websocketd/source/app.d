import websocketd.server;

class EchoServer : WebSocketServer {
    private string[PeerID] peers;

    override void onOpen(PeerID s, string path) {
        peers[s] = path;
    }

    override void onClose(PeerID s) {
        peers.remove(s);
    }

    override void onTextMessage(PeerID src, string msg) {
        send!(sendText, typeof(msg))(src, msg);
    }

    override void onBinaryMessage(PeerID s, ubyte[] o) {
    }

    private void send(alias sender, T)(PeerID src, T msg) {
        string srcPath = peers[src];
        foreach (id, path; peers)
            if (id != src)
                sender(id, msg);
    }
}

void main() {
    WebSocketServer server = new EchoServer();

    server.run!(8080, 10);
}
