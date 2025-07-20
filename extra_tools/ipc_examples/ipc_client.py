import socket

def udp_client():
    # Define the server address and port
    server_address = ('127.0.0.1', 12345)
    
    # Create a UDP socket
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    message = "Hello, UDP Server!"
    
    try:
        # Send the message to the server
        client_socket.sendto(message.encode(), server_address)
        print(f"Sent message: {message}")
    
    finally:
        client_socket.close()

if __name__ == "__main__":
    udp_client()
