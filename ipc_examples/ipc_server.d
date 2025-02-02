import std;

void udp_server() {
    auto server_address = new InternetAddress("127.0.0.1", 12345);

    auto socket = new UdpSocket();
    socket.setOption(SocketOptionLevel.SOCKET, SocketOption.BROADCAST, true);
    socket.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);

    socket.bind(server_address);
    writeln(i"Server listening on $(server_address)");

    while (true) {
        ubyte[4096] buf;
        auto recv = socket.receive(buf);
        writeln(i"Received message: $(cast(char[])buf[0..recv])");
    }
}

void main() {
    udp_server();
}
