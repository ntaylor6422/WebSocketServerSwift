import Vapor

var env = try Environment.detect()
let app = Application(env)

defer {
    app.shutdown()
}

var clientConnections = Set<WebSocket>()

app.webSocket("game") { req, client in
    clientConnections.insert(client)
    
    client.onClose.whenComplete {
        _ in clientConnections.remove(client)
    }
    
    client.onText {_, text in
        do {
            guard let data = text.data(using: .utf8) else {
                return
            }
            let incoming = try JSONDecoder().decode(Result.self, from: data)
            let outgoing = Board(matrix: incoming.matrix)
            let json = try JSONEncoder().encode(outgoing)
            
            guard let jsonString = String(data: json, encoding: .utf8) else {
                return
            }
            
            for connection in clientConnections {
                connection.send(jsonString)
            }
        }
        catch {
            print(error)
        }
    }
    
}


try app.run()


extension WebSocket: Hashable {
    public static func == (lhs: WebSocket, rhs: WebSocket) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
