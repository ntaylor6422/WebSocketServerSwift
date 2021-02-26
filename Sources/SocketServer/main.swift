import Foundation
import NIO
import Vapor
import WebSocketKit

var env = try Environment.detect()
let app = Application(env)

//@Published var newMatrix:[[Int]] = []

class MatrixData:ObservableObject {
    @Published var matrix:[[Int]] = []
    
    func createMatrix(totalPrice: String) -> [[Int]]{
        let toDouble = Double(totalPrice)!
        let rdDown = Int(floor(toDouble)) / 2
        var arr:[[Int]] = []
        
        for _ in 0...3 {
            var tempArr:[Int] = []
            for _ in 0...3 {
                let random = Int.random(in: 0..<rdDown)
                tempArr.append(random)
            }
            arr.append(tempArr)
        }
        self.matrix = arr
        return arr
    }
}



defer {
    app.shutdown()
}

var clientConnections = Set<WebSocket>()

app.webSocket("game") { req, client in
    client.pingInterval = .seconds(10)
    
    clientConnections.insert(client)
    
    client.onClose.whenComplete { _ in
        clientConnections.remove(client)
    }
    
    
    
    /*func createMatrix(totalPrice: String) -> [[Int]]{
        let toDouble = Double(totalPrice)!
        let rdDown = Int(floor(toDouble)) / 2
        var arr:[[Int]] = []
        
        for _ in 0...3 {
            var tempArr:[Int] = []
            for _ in 0...3 {
                let random = Int.random(in: 0..<rdDown)
                tempArr.append(random)
            }
            arr.append(tempArr)
        }
        Matrix.matrix = arr
        return arr
    }*/
    
    client.onText { ws, text in
        do {
            guard let data = text.data(using: .utf8) else {
                return
            }
            
            let Matrix: MatrixData = MatrixData()

            let incomingMessage = try JSONDecoder().decode(Result.self, from: data)
            
            print(incomingMessage.total.count, Matrix.matrix)
            
            let matrix = incomingMessage.total.count > 0 ? Matrix.createMatrix(totalPrice: incomingMessage.total) : Matrix.matrix
            
            print(matrix)

            let outgoingMessage = Board(matrix: matrix)
            
            let json = try JSONEncoder().encode(outgoingMessage)
            
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

