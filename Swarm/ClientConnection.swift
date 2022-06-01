import Foundation
import Network

@available(macOS 10.14, *)
class ClientConnection {

    let nwConnection: NWConnection
    let queue = DispatchQueue(label: "Client connection Q")

    init(nwConnection: NWConnection) {
        self.nwConnection = nwConnection
    }

    var didStopCallback: ((Error?) -> Void)? = nil

    func start() {
        print("\(nwConnection) connection will start")
        nwConnection.stateUpdateHandler = stateDidChange(to:)
        setupReceive()
        nwConnection.start(queue: queue)
    }

    private func stateDidChange(to state: NWConnection.State) {
        switch state {
        case .waiting(let error):
            print("\(nwConnection) connectionDidFail \(error)")
            connectionDidFail(error: error)
        case .ready:
            print("\(nwConnection) Client connection ready")
        case .failed(let error):
            print("\(nwConnection) connectionDidFail \(error)")
            connectionDidFail(error: error)
        default:
            break
        }
    }

    private func setupReceive() {
        nwConnection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, _, isComplete, error) in
            if let data = data, !data.isEmpty {
                let message = String(data: data, encoding: .utf8)
                print("connection \(self.nwConnection) did receive, data: \(data as NSData) string: \(message ?? "-" )")
            }
            if isComplete {
                self.connectionDidEnd()
            } else if let error = error {
                self.connectionDidFail(error: error)
            } else {
                self.setupReceive()
            }
        }
    }

    public typealias SendHandler = @convention(block) () -> Void

    func send(data: Data, handler: SendHandler? = nil) {
        nwConnection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                self.connectionDidFail(error: error)
                return
            }
            print("connection \(self.nwConnection) did send, data: \(data as NSData)")
            if let handler = handler {
                handler()
            }
        }))
    }

    func stop() {
        print("connection \(nwConnection) will stop")
        stop(error: nil)
    }

    private func connectionDidFail(error: Error) {
        print("connection \(nwConnection) did fail, error: \(error)")
        self.stop(error: error)
    }

    private func connectionDidEnd() {
        print("connection \(nwConnection) did end")
        self.stop(error: nil)
    }

    private func stop(error: Error?) {
        self.nwConnection.stateUpdateHandler = nil
        self.nwConnection.cancel()
        if let didStopCallback = self.didStopCallback {
            self.didStopCallback = nil
            didStopCallback(error)
        }
    }
}
