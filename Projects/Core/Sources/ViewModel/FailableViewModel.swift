import Foundation

public protocol FailableViewModel: AnyObject {
    var error: Error? { get set }
    var hasError: Bool { get set }
}

public extension FailableViewModel {
    var hasError: Bool {
        get {
            error != nil
        }
        set {
            if !newValue {
                error = nil
            }
        }
    }
}
