module app;

import std;
import serverino;

@onWebSocketUpgrade bool onUpgrade(Request req)
{
    return true;
}

@route!"/"@endpoint void echo(Request r, WebSocket ws)
{
    auto ws_id = randomUUID().toString();

    ws.socket.blocking = false;

    auto sck = new UdpSocket();
    // set broadcast flag
    sck.setOption(SocketOptionLevel.SOCKET, SocketOption.BROADCAST, true);
	sck.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);

	auto bc = new InternetAddress("255.255.255.255",12345);
    sck.bind(bc);
    sck.blocking = false;

    try
    {
        while (true)
        {
            if (WebSocketMessage msg = ws.receiveMessage()) {
                sck.sendTo(ws_id ~ ":" ~ msg.asString, bc);
            }

            ubyte[4096] buf;
            auto len = sck.receive(buf);
            if (len > 0) {
			    auto chrs = cast(char[])buf[0..len];
                log("Buf:",chrs);
                if (!chrs.startsWith(ws_id)) {
                    string txt = chrs.to!string;
                    txt = txt.split(":")[1];
                    log("Msg:",txt);
                    ws.send(txt);
			    }
            }
        }
    }
    catch (Exception e)
    {
        writeln(e);
    }
}

mixin ServerinoMain;
