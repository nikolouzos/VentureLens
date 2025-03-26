public protocol Command {
    func execute() async throws
}

public struct LazyCommand<Wrapped: Command>: Command {
    private let internalCommand: Wrapped

    public init(_ internalCommand: Wrapped) {
        self.internalCommand = internalCommand
    }

    public func execute() async throws {
        Task {
            try await internalCommand.execute()
        }
    }
}
