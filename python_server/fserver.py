from fastapi import FastAPI, WebSocket

app = FastAPI()
connected = set()

@app.websocket("/")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    connected.add(websocket)
    try:
        while True:
            msg = await websocket.receive_text()
            for client in connected:
                if client is not websocket:
                    await client.send_text(msg)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        await websocket.close()  # Close the connection when done

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
