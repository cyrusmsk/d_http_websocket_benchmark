import lighttp;
import std.stdio : writeln;
import std.array : byPair;

class EchoServer {
    private EchoServer.Connection[uint] connections;

    @Get("") class Connection : WebSocket {
        private static uint _id = 0;

        public uint id;

        void onConnect(ServerRequest request) {
            this.id = _id++;
            connections[id] = this;
            writeln(request);
        }

        override void onClose() {
            connections.remove(this.id);
        }

        override void onReceive(ubyte[] data) {
            writeln(data);
            foreach(connection; connections.byPair)
                if (connection.key != this.id)
                    connection.value.send(cast(string)data);
        }
    }
}

void main() {
    auto server = new Server();
    server.host("0.0.0.0", 8080);
    server.router.add(new EchoServer());
    server.run();
}
