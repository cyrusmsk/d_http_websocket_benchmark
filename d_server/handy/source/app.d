import handy_httpd;
import std.stdio;
import std.parallelism;
import std.uuid;

class Echo: WebSocketMessageHandler {
    shared WebSocketConnection[] connected;
    override void onConnectionEstablished(WebSocketConnection conn) {
        connected ~= cast(shared)conn;
    }

    override void onTextMessage(WebSocketTextMessage msg) {
        auto send_task = task(&async_send, connected, msg.conn.id, msg.payload);
        send_task.executeInNewThread();
    }

    void async_send(shared WebSocketConnection[] connect, UUID id, string text) {
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
