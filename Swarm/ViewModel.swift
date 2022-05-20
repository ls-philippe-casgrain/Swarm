//
//  ViewModel.swift
//  Swarm
//
//  Created by Philippe Casgrain on 2022-05-20.
//

import Foundation
import SwiftUI


protocol ViewModelType: ObservableObject {

    // Output
    var message: String { get }
    var swarmCount: Double { get set }
    var bees: [Bee] { get }

    // Input
    var cancel: () -> Void { get }
    var swarm: () -> Void { get }
}

class ViewModel: ViewModelType {

    @Published var bees: [Bee] = [Bee(id: 0, message: "Just a bee")]

    var swarmCount: Double {
        get {
            Double(self.bees.count)
        }
        set {
            let total = Int(newValue)
            self.bees = []
            for i in 1...total {
                self.bees.append(Bee(id: i, message: "\(i)"))
            }
            print("Updated bees: \(self.bees.count)")
        }
    }
    
    var message: String {
        "Hello, world!"
    }

    lazy var cancel: () -> Void = {
        print("cancel")
    }

    lazy var swarm: () -> Void = {
        for bee in self.bees {
            bee.sendToPrinter()
        }
    }
}
