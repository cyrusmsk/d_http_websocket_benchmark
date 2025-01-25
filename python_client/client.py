import asyncio
import websockets
import time

async def client1():
    try:
        async with websockets.connect('ws://localhost:8080') as websocket:
            print("Client1 connected")
            round_trips = 0
            start = time.time_ns()
            await websocket.send('allo')
            while True:
                response = await websocket.recv()
                print(f"Client1 recved: {response}")
                round_trips += 1
                if(round_trips % 65536 == 0):
                    end = time.time_ns()
                    duration = (end - start)/1000000000
                    print("rate: ",round_trips/duration," round trips per second")
                await websocket.send('allo')
    except websockets.exceptions.ConnectionClosed:
        print("Соединение закрыто")
    except Exception as e:
        print(f"Ошибка: {e}")

async def client2():
    try:
        async with websockets.connect('ws://localhost:8080') as websocket:
            print("Client2 connected")
            while True:
                response = await websocket.recv()
                print(f"Client2 recved: {response}")
                await websocket.send('allo!')
    except websockets.exceptions.ConnectionClosed:
        print("Client2 Соединение закрыто")
    except Exception as e:
        print(f"Client2 Ошибка: {e}")

async def main():
    task1 = asyncio.create_task(client1())
    task2 = asyncio.create_task(client2())
    await asyncio.gather(task1, task2)

asyncio.run(main())
