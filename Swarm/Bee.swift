//
//  Bee.swift
//  Swarm
//
//  Created by Philippe Casgrain on 2022-05-20.
//

import Foundation

struct Bee: Identifiable {

    let id: Int

    let message: String

    let client = Client(host: "10.50.28.91", port: 9100)

    func sendToPrinter() {
        let label = String(format: "%02d", id)
        print("\(id) Sending to printer")
        guard let filePath = Bundle.main.path(forResource: label, ofType: "txt", inDirectory: "Numbers") else {
            print("unable to locate ascii art")
            return
        }
        do {
            let asciiArt = try String(contentsOfFile: filePath).data(using: .utf8) ?? Data()
//            let asciiArt = try Data(contentsOf: URL.init(fileURLWithPath: filePath))
            let queue = DispatchQueue(label:label)
            queue.async {
                sendToNetworkPrinter(message: asciiArt)
            }
        } catch {
            print("unable to load ascii art")
            return
        }
    }

    private func sendToNetworkPrinter(message: Data) {

        client.start()
        client.connection.send(data: Data([0x1B, 0x40])) // Initialize
//        client.connection.send(data: Data([0x1D, 0x61, 0x04])) // Real-time status
        client.connection.send(data: Data([0x1B, 0x2D, 0x00]))
        client.connection.send(data: message)
        client.connection.send(data: Data([0x00, 0x1D, 0x56, 0x41, 0x03]))
        client.connection.stop()
//        client.connection.send(data: "Hello, world".data(using: .ascii)!)
//        client.connection.send(data: Data([0x00, 0x1D, 0x56, 0x41, 0x03])) // Close
//        client.stop()
//        while(true) {
//            var command = readLine(strippingNewline: true)
//            switch (command){
//            case "CRLF":
//                command = "\r\n"
//            case "RETURN":
//                command = "\n"
//            case "exit":
//                client.stop()
//            default:
//                break
//            }
//            var data = Data()
//            data.append((command?.data(using: .utf8))!)
//            client.connection.send(data: data)
//        }
    }
}
