import socket

def udp_server():
    # Define the server address and port
    server_address = ('127.0.0.1', 12345)
    
    # Create a UDP socket
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    # Bind the socket to the server address
    server_socket.bind(server_address)
    
    print(f"Server listening on {server_address}")
    
    while True:
        # Wait for incoming messages
        data, client_address = server_socket.recvfrom(4096)
        print(f"Received message from {client_address}: {data.decode()}")

        # Optionally send a response to the client (can be left empty if no response needed)
        # server_socket.sendto(b"Message received", client_address)

if __name__ == "__main__":
    udp_server()
