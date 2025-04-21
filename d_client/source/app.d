import std;
import core.thread;

import std.datetime.stopwatch : StopWatch, AutoStart;

import serverino;

void client1()
{
    auto handshake = "GET / HTTP/1.1\r\nHost: localhost:8080\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Version: 13\r\n\r\n";

    auto sck = new TcpSocket();
    sck.setOption(SocketOptionLevel.TCP, SocketOption.TCP_NODELAY, 1);
    sck.blocking = true;
    sck.connect(new InternetAddress("localhost", 8080));
    sck.send(handshake);

    ubyte[] buffer;
    buffer.length = 129;

    {
        auto ln = sck.receive(buffer);
        auto reply = buffer[0 .. ln];
    }
    WebSocket ws = new WebSocket(sck, WebSocket.Role.Client);
    writeln("Client1 connected");
    long round_trips;
    StopWatch sw;
    sw.start();
    ws.sendMessage(WebSocketMessage("allo"), true);
    while (true)
    {
        buffer.length = 32000;
        ubyte[] reply;

        while (reply.length < "allo!".length)
        {
            auto recv = sck.receive(buffer);
            if (recv <= 0)
            {
                version (Posix)
                {
                    import core.stdc.errno : errno, EINTR;

                    if (errno == EINTR)
                    {
                        warning("EINTR");
                        continue;
                    }
                }
                break;
            }

            reply ~= buffer[0 .. recv];
        }

        round_trips++;
        if (round_trips % 65536 == 0)
        {
            auto duration = sw.peek();
            writeln("rate: ", round_trips / (duration.total!"seconds"), " round trips per second");
        }
        if (round_trips > 65536 * 3)
        {
            ws.sendClose();
            return;
        }
        ws.sendMessage(WebSocketMessage("allo"), true);
    }
}

void client2()
{
    auto handshake = "GET / HTTP/1.1\r\nHost: localhost:8080\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Version: 13\r\n\r\n";

    auto sck = new TcpSocket();
    sck.setOption(SocketOptionLevel.TCP, SocketOption.TCP_NODELAY, 1);
    sck.blocking = true;
    sck.connect(new InternetAddress("localhost", 8080));
    sck.send(handshake);

    ubyte[] buffer;
    buffer.length = 129;

    {
        auto ln = sck.receive(buffer);
        auto reply = buffer[0 .. ln];
    }
    WebSocket ws = new WebSocket(sck, WebSocket.Role.Client);
    writeln("Client2 connected");
    int i = 0;
    while (true)
    {
        buffer.length = 32000;
        ubyte[] reply;

        while (reply.length < "allo".length)
        {
            auto recv = sck.receive(buffer);
            if (recv <= 0)
            {
                version (Posix)
                {
                    import core.stdc.errno : errno, EINTR;

                    if (errno == EINTR)
                    {
                        warning("EINTR");
                        continue;
                    }
                }
                break;
            }

            reply ~= buffer[0 .. recv];
        }
        if (++i > 66000 * 3)
        {
            ws.sendClose();
            return;
        }
        ws.sendMessage(WebSocketMessage("allo!"), true);
    }
}

void main()
{
    auto cl2 = task!client2;
    cl2.executeInNewThread();
    client1();

    writeln("Both tasks completed");
}
