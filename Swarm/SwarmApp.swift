//
//  SwarmApp.swift
//  Swarm
//
//  Created by Philippe Casgrain on 2022-05-20.
//

import SwiftUI

@main
struct SwarmApp: App {

    let viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
