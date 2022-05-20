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

    func sendToPrinter() {
        print("\(id) Sending to printer")
        guard let filePath = Bundle.main.path(forResource: String(format: "%02d", id), ofType: "txt", inDirectory: "Numbers") else {
            print("unable to locate ascii art")
            return
        }
        do {
            let asciiArt = try String(contentsOfFile: filePath)
            sendToNetworkPrinter(text: asciiArt)
        } catch {
            print("unable to load ascii art")
            return
        }
    }

    private func sendToNetworkPrinter(text: String) {
        
    }
}
