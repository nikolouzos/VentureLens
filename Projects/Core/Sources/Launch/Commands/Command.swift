public protocol Command: AnyObject {
    func execute() async throws
}
