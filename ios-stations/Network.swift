import Network

final class Network {
    static let shared = Network()
    private let monitor = NWPathMonitor()

    func setUp() {
        monitor.start(queue: .global(qos: .background))
    }

    func isOnline() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
}
