import handy_httpd;
import std.stdio;
import std.parallelism;
import std.uuid;

shared WebSocketConnection[] connected;

class Echo: WebSocketMessageHandler {
    override void onConnectionEstablished(WebSocketConnection conn) {
        connected ~= cast(shared) conn;
    }

    override void onTextMessage(WebSocketTextMessage msg) {
        sync_send(connected, msg.conn.id, msg.payload);
    }

    void sync_send(shared WebSocketConnection[] connect, UUID id, string text) {
        foreach(con; connect)
            if (con.id != id)
                (cast(WebSocketConnection) con).sendTextMessage(text);
    }
}

void main() {
    ServerConfig cfg = ServerConfig();
    cfg.hostname = "0.0.0.0";
    cfg.port = 8080;
    cfg.enableWebSockets = true;

    auto handler = new WebSocketHandler(new Echo());
    new HttpServer(handler, cfg).start();
}
