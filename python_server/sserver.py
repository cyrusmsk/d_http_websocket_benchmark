import sanic

app = sanic.Sanic("WsExample")

connected = set()

@app.websocket('/')
async def echo(request, ws):
    connected.add(ws)
    try:
        while True:
            message = await ws.recv()
            for client in connected:
                if client is not ws:
                    await client.send(message)
    finally:
        connected.remove(ws)
