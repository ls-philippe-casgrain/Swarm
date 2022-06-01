//
//  ContentView.swift
//  Swarm
//
//  Created by Philippe Casgrain on 2022-05-20.
//

import SwiftUI

struct ContentView<Model: ViewModelType>: View {

    @ObservedObject var viewModel: Model

    var body: some View {
        VStack {
            HStack {
                Text("IP address")
                TextField(
                    "IP address",
                    text: self.$viewModel.ipAddress
                )
            }.padding()
            HStack {
                Text("Number of bees")
                Slider(
                    value: self.$viewModel.swarmCount,
                    in: 1...20,
                    step: 1
                )
                .padding()
            }
            .padding()

            List(self.viewModel.bees) { bee in
                Text("\(bee.message)")
            }
            .padding()

            HStack {
                Button("Cancel", role: .cancel, action: self.viewModel.cancel)
                    .padding(EdgeInsets(top: 18,
                                        leading: 30,
                                        bottom: 18,
                                        trailing: 30))
                Button("Swarm", action: self.viewModel.swarm)
                    .keyboardShortcut(.defaultAction)
                    .padding(EdgeInsets(top: 18,
                                        leading: 30,
                                        bottom: 18,
                                        trailing: 30))
            }

            Text(self.viewModel.message)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    fileprivate static var testViewModel = TestViewModel()

    static var previews: some View {
        ContentView(viewModel: testViewModel)
    }
}

fileprivate class TestViewModel: ViewModelType {

    var bees: [Bee] = [Bee(id: 0, message: "Test bee", host: "127.0.0.1")]

    var message: String = "Sphinx of black quartz, judge my vow"
    var swarmCount: Double = 3.0
    var ipAddress: String = "127.0.0.1"

    var cancel: () -> Void = {}
    var swarm: () -> Void = {}
}
