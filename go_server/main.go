package main

import (
  "fmt"
  "net"
  "net/http"

  "github.com/olahol/melody"
)

var (
  clients map[net.Addr]*melody.Session
)

const (
  MAX_CLIENTS int = 64
)

func main() {
  clients = make(map[net.Addr]*melody.Session, MAX_CLIENTS)

  m := melody.New()

  http.HandleFunc("GET /", func(w http.ResponseWriter, r *http.Request) {
    fmt.Println("HandleFunc")
    m.HandleRequest(w, r)
  })

  m.HandleConnect(func(session *melody.Session) {
    fmt.Println("New client connected")
    clients[session.RemoteAddr()] = session
  })

  m.HandleDisconnect(func(session *melody.Session) {
    delete(clients, session.RemoteAddr())
  })

  m.HandleMessage(func(sender *melody.Session, data []byte) {
    fmt.Println("HandleMessage")
    m.BroadcastFilter(data, func(receiver *melody.Session) bool {
      return sender != receiver
    })
  })

  http.ListenAndServe("localhost:8080", nil)
}
