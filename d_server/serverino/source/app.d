module app;

import std;
import serverino;

enum ushort PORT = 5555;

@onWebSocketUpgrade onUpgrade(Request request) => true;

// Handle the WebSocket connection
@endpoint void echo(Request r, WebSocket ws) {

    auto myid = randomUUID().toString();
    auto address = new InternetAddress("127.255.255.255", PORT);

    auto socket = new UdpSocket();
    socket.setOption(SocketOptionLevel.SOCKET, SocketOption.BROADCAST, true);
    socket.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
    socket.setOption(SocketOptionLevel.SOCKET, cast(SocketOption) SO_REUSEPORT, true);
    socket.bind(address);

    SocketSet ss = new SocketSet();

    // Read messages from the client
    while (true) {

        ss.reset();
        ss.add(socket);
        ss.add(ws.socket);

        if (Socket.select(ss, null, null) < 0) break;

        // Broadcast message to all clients if websocket receives a message
        if (ss.isSet(ws.socket))
            if (WebSocketMessage msg = ws.receiveMessage())
                socket.sendTo(myid ~ msg.asString, address);

        // Read broadcast messages
        if (ss.isSet(socket))
        {
            ubyte[1464] buf;
            auto len = socket.receive(buf);

            if (len > 0 && len > myid.length)
            {
                auto sender = cast(char[])buf[0..myid.length];
                auto msg = cast(char[])buf[myid.length..len];

                if (sender != myid)
                {
                    ws.send(cast(string)msg);
                }
            }
        }
    }
}

mixin ServerinoMain;
