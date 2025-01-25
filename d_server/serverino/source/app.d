module app;

import std.stdio: writeln;
import serverino;

@onWebSocketUpgrade bool onUpgrade(Request req)
{
    return req.path == "/";
}

@route!"/"@endpoint void echo(Request r, WebSocket ws)
{
    try
    {
        while (true)
        {
            WebSocketMessage msg = ws.receiveMessage();
            ws.send(msg.asString);
        }
    }
    catch (Exception e)
    {
        writeln(e);
    }
}

mixin ServerinoMain;
