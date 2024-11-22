import vibe.core.core : runApplication;
import vibe.http.router;
import vibe.http.websockets;
import vibe.http.server;

shared WebSocket[] connections;

void handleConn(scope WebSocket sock)
{
	connections ~= cast(shared) sock;
	// simple echo server
	while (true) {
		auto msg = sock.receiveText();
		foreach(con; connections)
			if (con != sock)
				(cast(WebSocket) con).send(msg);
	}
}

void main(string[] args)
{
	auto router = new URLRouter;
	router.get("/", handleWebSockets(&handleConn));

    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    settings.bindAddresses = ["0.0.0.0"];
    listenHTTP(settings, router);

	runApplication();
}
