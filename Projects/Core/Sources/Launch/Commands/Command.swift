public protocol Command {
    func execute() async throws
}
