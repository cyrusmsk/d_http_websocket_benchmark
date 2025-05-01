import asyncio
import websockets
import time
import json

async def client1():
    try:
        async with websockets.connect('ws://localhost:8080/') as websocket:
            file_path = "../output/data.json"
            results = []
            with open(file_path, 'r') as file:
                json_data = json.load(file)
            print("Client1 connected")
            round_trips = 0
            start = time.time_ns()
            await websocket.send('allo')
            while True:
                response = await websocket.recv()
                #print(f"Client1 recved: {response}")
                round_trips += 1
                if(round_trips % 65536 == 0):
                    end = time.time_ns()
                    duration = (end - start)/1000000000
                    #print("rate: ",round_trips/duration," round trips per second")
                    results.append(round_trips//duration)
                if(round_trips > 65536*3):
                    json_data['py_data'].append({'d-handy': results})
                    with open(file_path, 'w') as file:
                        json.dump(json_data, file, indent=2)
                    print("Client1 finished")
                    print(results)
                    return;
                await websocket.send('allo')
    except websockets.exceptions.ConnectionClosed:
        print("Client1 connection is closed")
    except Exception as e:
        print(f"Client1 Error: {e}")

async def client2():
    try:
        async with websockets.connect('ws://localhost:8080/') as websocket:
            print("Client2 connected")
            while True:
                response = await websocket.recv()
                await websocket.send('allo!')
    except websockets.exceptions.ConnectionClosed:
        print("Client2 connection is closed")
    except Exception as e:
        print(f"Client2 Error: {e}")

async def main():
    task1 = asyncio.create_task(client1())
    task2 = asyncio.create_task(client2())
    await asyncio.gather(task1, task2)
    print("Finished")

asyncio.run(main())
