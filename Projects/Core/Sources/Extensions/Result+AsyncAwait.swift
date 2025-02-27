import Foundation

public extension Result {
    func throwable() throws -> Success {
        switch self {
        case .success(let result):
            return result
            
        case .failure(let error):
            throw error
        }
    }
}
