import std;

void udp_client() {
    auto server_address = new InternetAddress("127.0.0.1", 12345);

    auto client_socket = new UdpSocket();
    string msg = "Hello server";

    client_socket.sendTo(msg, server_address);
    writeln("Send message");
    client_socket.close();
}

void main() {
    udp_client();
}
