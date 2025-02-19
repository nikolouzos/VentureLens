import Foundation

class EnvironmentVariables {
    static func get(key: EnvironmentVariableKeys) -> String {
        let dependenciesBundle = Bundle(for: EnvironmentVariables.self)
        guard let value = dependenciesBundle.object(forInfoDictionaryKey: key.rawValue) as? String else {
            fatalError("""
                Couldn't find \(key.rawValue) environment variable. 
                Please make sure your environment is configured correctly.
                """)
        }
        return value
    }
}
