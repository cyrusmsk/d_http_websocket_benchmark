module app;

import std;
import serverino;

shared WebSocket[] connected;

@onWebSocketUpgrade bool onUpgrade(Request req)
{
    return req.path == "/";
}

@route!"/"@endpoint void echo(Request r, WebSocket ws)
{
    connected ~= cast(shared)ws;
    try
    {
        while (true)
        {
            WebSocketMessage msg = ws.receiveMessage();
            foreach (con; connected)
                if (con != ws)
                    (cast(WebSocket) con).send(msg.asString);
        }
    }
    catch (Exception e)
    {
        writeln(e);
    }
}

mixin ServerinoMain;
