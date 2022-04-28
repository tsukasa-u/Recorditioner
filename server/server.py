from glob import glob
# from websocket_server import WebsocketServer
import logging
import json
import os

import socket
import struct
import time

import asyncio
from websockets import serve

import multiprocessing

async def echo(websocket):
    async for message in websocket:
        print(message)
        data = json.loads(message)
        SerialNumber = data["id"]
        if (data["data"] == 0):
            path = f"./data/{SerialNumber}"
            fileList = os.listdir(path)
            await websocket.send(
                f"""{{
                    \"id\":\"{SerialNumber}\",
                    \"data\": {fileList}
                }}"""
            )

        if (data["data"] == -1):
            with open(f'data/{SerialNumber}/info', 'r') as f:
                json_data = json.load(f)
                f.close()
                print(json_data)
            with open(f'data/{SerialNumber}/{json_data["file"]}', 'rb') as f:
                await websocket.send(f.read()[json_data["length"]:])
                f.close()
            
            with open(f'data/{SerialNumber}/info', 'r') as f:
                json_data = json.load(f)
                json_data["length"] = len(sendData)
                json_data["file"] = epoch
                f.close()
            with open(f'data/{SerialNumber}/info','w') as s:
                json.dump(json_data, s, indent=2)
                s.close()

        
        epoch = data["data"]

        if (epoch=="info" and os.path.exists(f'data/{SerialNumber}/{epoch}')):
            print(f'data/{SerialNumber}/{epoch}')
            with open(f'data/{SerialNumber}/info', 'r') as f:
                json_data = json.load(f)
                f.close()
            await websocket.send(str(json_data))

        if (epoch!="info" and os.path.exists(f'data/{SerialNumber}/{epoch}')):
            print(f'data/{SerialNumber}/{epoch}')
            with open(f'data/{SerialNumber}/{epoch}', 'rb') as f:
                sendData = f.read()
                await websocket.send( 
                    f"""{{
                        \"id\":\"{SerialNumber}\",
                        \"data\":\"{epoch}\"
                    }}"""
                )
                
                        # \"length\": {len(sendData)}
                await websocket.send(bytearray(sendData))
                # print(sendData)
                # await websocket.send_binary()
                f.close()
            with open(f'data/{SerialNumber}/info', 'r') as f:
                json_data = json.load(f)
                json_data["length"] = len(sendData)
                json_data["file"] = epoch
                f.close()
            with open(f'data/{SerialNumber}/info','w') as s:
                json.dump(json_data, s, indent=2)
                s.close()
            
        # await websocket.send(message)

async def toInterface():
    # async with serve(echo, "192.168.10.102", 9001):
    async with serve(echo, "192.168.128.124", 9001):
        await asyncio.Future()  # run forever

def startToInterface():
    asyncio.run(toInterface())


class EchoServerProtocol(asyncio.Protocol):
    def connection_made(self, transport):
        peername = transport.get_extra_info('peername')
        print('Connection from {}'.format(peername))
        self.transport = transport

    def data_received(self, message):
        # print(message)
        # data = message.decode()
        data = list(message)
        # print(data)
        # print('Data received: {!r}'.format(message))
        # print((f'data/{data[0:4]}/{data[4:8]}'))
        filename1 = f'{data[0]:0>2X}{data[1]:0>2X}{data[2]:0>2X}{data[3]:0>2X}'
        filename2 = f'{data[4]:0>2X}{data[5]:0>2X}{data[6]:0>2X}{data[7]:0>2X}'
        if (not os.path.exists(f'data/{filename1}/{filename2}')):
            with open(f'data/{filename1}/{filename2}', 'ab') as f:
                f.write(b"dat ")
                f.write(struct.pack('I', 49)) #size of header
                f.write(struct.pack('I', data[4:8]))
                f.write(struct.pack('I', 600000))
                f.write(bytes([0x04]))
                f.write(bytes([len("acc")]))
                f.write(bytes([len("temp")]))
                f.write(bytes([len("press")]))
                f.write(bytes([len("humi")]))
                f.write(b"acc")
                f.write(b"temp")
                f.write(b"press")
                f.write(b"humi")
                f.write(bytes([4]))
                f.write(bytes([4]))
                f.write(bytes([4]))
                f.write(bytes([4]))
                f.write(b"f")
                f.write(b"f")
                f.write(b"f")
                f.write(b"f")
                f.close()
            
        with open(f'data/{filename1}/{filename2}', 'ab') as f:
            # for data_i in data[8:]:
            for data_i in data[8:]:
                # f.write(bytes(data_i, encoding = "utf-8"))
                f.write(bytes([data_i]))
            f.close()

        with open(f'data/{filename1}/info', 'r') as f:
            json_data = json.load(f)
            json_data["file"] = filename2
            f.close()
        with open(f'data/{filename1}/info','w') as s:
            json.dump(json_data, s, indent=2)
            s.close()

        # print('Send: {!r}'.format(message))
        # self.transport.write(data)

        # print('Close the client socket')
        # self.transport.close()


async def toDevice():
    loop = asyncio.get_running_loop()

    # server = await loop.create_server(lambda: EchoServerProtocol(), "192.168.10.102", 8080)
    server = await loop.create_server(lambda: EchoServerProtocol(), "192.168.128.124", 8080)

    async with server:
        await server.serve_forever()


# asyncio.run(toDevice())

def startToDevice():
    asyncio.run(toDevice())

if __name__ == '__main__':
    p1 = multiprocessing.Process(name="p1", target=startToInterface)
    p2 = multiprocessing.Process(name="p2", target=startToDevice)

    p1.start()
    p2.start()

    
    p1.join()
    p2.join()