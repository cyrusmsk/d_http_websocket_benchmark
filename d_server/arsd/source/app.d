import arsd.cgi;

shared WebSocket[] connections;

void websocketEcho(Cgi cgi)
{
    if (cgi.websocketRequested())
    {
        auto ws = cgi.acceptWebsocket();

        connections ~= cast(shared)ws;

        while (true)
        {
            auto msg = ws.recv();

            if (msg.opcode == WebSocketOpcode.text) {
                foreach(con; connections)
                    if (con != ws)
                        (cast(WebSocket)con).send(msg.textData);
            }
        }

        ws.close();
    }
    else
    {
        cgi.write("You are loading the websocket endpoint in a browser instead of a websocket client. Use a websocket client on this url instead.\n", true);
    }
}

mixin GenericMain!websocketEcho;
