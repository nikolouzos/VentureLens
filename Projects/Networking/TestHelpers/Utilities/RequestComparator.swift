import Foundation
import XCTest

/// Utility for comparing network requests with flexible comparison options
public struct RequestComparator {
    /// Comparison options to specify how strict the comparison should be
    public struct ComparisonOptions: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// Ignore timestamp fields in the comparison
        public static let ignoreTimestamps = ComparisonOptions(rawValue: 1 << 0)
        
        /// Ignore ID fields in the comparison
        public static let ignoreIds = ComparisonOptions(rawValue: 1 << 1)
        
        /// Ignore null/nil values in the comparison
        public static let ignoreNulls = ComparisonOptions(rawValue: 1 << 2)
        
        /// Compare only the keys, not the values
        public static let keysOnly = ComparisonOptions(rawValue: 1 << 3)
        
        /// Ignore order in arrays
        public static let ignoreArrayOrder = ComparisonOptions(rawValue: 1 << 4)
        
        /// Default options
        public static let `default`: ComparisonOptions = []
    }
    
    /// Fields that should be considered timestamps and ignored when ignoreTimestamps is enabled
    private let timestampFields: [String]
    
    /// Fields that should be considered IDs and ignored when ignoreIds is enabled
    private let idFields: [String]
    
    /// Creates a request comparator with the specified field names
    /// - Parameters:
    ///   - timestampFields: Field names that should be considered timestamps
    ///   - idFields: Field names that should be considered IDs
    public init(
        timestampFields: [String] = ["timestamp", "created_at", "updated_at", "date", "time"],
        idFields: [String] = ["id", "uuid", "identifier"]
    ) {
        self.timestampFields = timestampFields
        self.idFields = idFields
    }
    
    /// Compares two dictionaries with the specified options
    /// - Parameters:
    ///   - dict1: The first dictionary
    ///   - dict2: The second dictionary
    ///   - options: Comparison options to control strictness
    /// - Returns: Whether the dictionaries are equal according to the options
    public func areEqual(
        _ dict1: [String: Any],
        _ dict2: [String: Any],
        options: ComparisonOptions = .default
    ) -> Bool {
        // Check if we're only comparing keys
        if options.contains(.keysOnly) {
            return Set(dict1.keys) == Set(dict2.keys)
        }
        
        // Get the keys to compare
        let keys1 = Set(dict1.keys)
        let keys2 = Set(dict2.keys)
        
        // Check keys match
        guard keys1 == keys2 else {
            return false
        }
        
        // Compare each key
        for key in keys1 {
            let value1 = dict1[key]
            let value2 = dict2[key]
            
            // Skip timestamps if ignoring them
            if options.contains(.ignoreTimestamps) && isTimestampField(key) {
                continue
            }
            
            // Skip IDs if ignoring them
            if options.contains(.ignoreIds) && isIdField(key) {
                continue
            }
            
            // Handle null values
            if value1 == nil || value2 == nil {
                if options.contains(.ignoreNulls) {
                    continue
                }
                if (value1 == nil) != (value2 == nil) {
                    return false
                }
                continue
            }
            
            // Compare dictionaries recursively
            if let dict1 = value1 as? [String: Any], let dict2 = value2 as? [String: Any] {
                if !areEqual(dict1, dict2, options: options) {
                    return false
                }
                continue
            }
            
            // Compare arrays
            if let array1 = value1 as? [Any], let array2 = value2 as? [Any] {
                if !areArraysEqual(array1, array2, options: options) {
                    return false
                }
                continue
            }
            
            // Basic equality check for other types
            if !areValuesEqual(value1, value2) {
                return false
            }
        }
        
        return true
    }
    
    /// Compares two arrays with the specified options
    /// - Parameters:
    ///   - array1: The first array
    ///   - array2: The second array
    ///   - options: Comparison options to control strictness
    /// - Returns: Whether the arrays are equal according to the options
    public func areArraysEqual(
        _ array1: [Any],
        _ array2: [Any],
        options: ComparisonOptions = .default
    ) -> Bool {
        // Quick check for length
        guard array1.count == array2.count else {
            return false
        }
        
        // If we're ignoring array order, we need to match items in any order
        if options.contains(.ignoreArrayOrder) {
            // This is a simplified approach for primitives - for complex objects
            // a more sophisticated algorithm would be needed
            let stringified1 = array1.map { String(describing: $0) }.sorted()
            let stringified2 = array2.map { String(describing: $0) }.sorted()
            return stringified1 == stringified2
        }
        
        // Otherwise, compare in order
        for (i, item1) in array1.enumerated() {
            let item2 = array2[i]
            
            // Compare dictionaries
            if let dict1 = item1 as? [String: Any], let dict2 = item2 as? [String: Any] {
                if !areEqual(dict1, dict2, options: options) {
                    return false
                }
                continue
            }
            
            // Compare arrays recursively
            if let nestedArray1 = item1 as? [Any], let nestedArray2 = item2 as? [Any] {
                if !areArraysEqual(nestedArray1, nestedArray2, options: options) {
                    return false
                }
                continue
            }
            
            // Basic equality for other types
            if !areValuesEqual(item1, item2) {
                return false
            }
        }
        
        return true
    }
    
    /// Compares two arbitrary values for equality
    /// - Parameters:
    ///   - value1: The first value
    ///   - value2: The second value
    /// - Returns: Whether the values are equal
    private func areValuesEqual(_ value1: Any?, _ value2: Any?) -> Bool {
        // Handle nil values
        if value1 == nil && value2 == nil {
            return true
        }
        if value1 == nil || value2 == nil {
            return false
        }
        
        // Convert to strings for simple comparison
        // This is a simplified approach - for production use, a more sophisticated
        // algorithm that handles specific types would be better
        return String(describing: value1) == String(describing: value2)
    }
    
    /// Checks if a field is a timestamp field
    /// - Parameter field: The field name to check
    /// - Returns: Whether it's a timestamp field
    private func isTimestampField(_ field: String) -> Bool {
        return timestampFields.contains { field.lowercased().contains($0.lowercased()) }
    }
    
    /// Checks if a field is an ID field
    /// - Parameter field: The field name to check
    /// - Returns: Whether it's an ID field
    private func isIdField(_ field: String) -> Bool {
        return idFields.contains { field.lowercased().contains($0.lowercased()) }
    }
    
    // MARK: - XCTest Integration
    
    /// Asserts that two dictionaries are equal according to the specified options
    /// - Parameters:
    ///   - dict1: The first dictionary
    ///   - dict2: The second dictionary
    ///   - options: Comparison options to control strictness
    ///   - message: The failure message
    public func XCTAssertEqual(
        _ dict1: [String: Any],
        _ dict2: [String: Any],
        options: ComparisonOptions = .default,
        message: String = ""
    ) {
        if !areEqual(dict1, dict2, options: options) {
            let optionsStr = describeOptions(options)
            let details = "Dictionaries not equal with options: \(optionsStr)"
            let failMessage = message.isEmpty ? details : "\(message) - \(details)"
            
            XCTFail(failMessage)
            
            // Log the differences for debugging
            logDifferences(dict1, dict2, options: options)
        }
    }
    
    /// Logs the differences between two dictionaries for debugging
    /// - Parameters:
    ///   - dict1: The first dictionary
    ///   - dict2: The second dictionary
    ///   - options: The comparison options used
    private func logDifferences(
        _ dict1: [String: Any],
        _ dict2: [String: Any],
        options: ComparisonOptions
    ) {
        let keys1 = Set(dict1.keys)
        let keys2 = Set(dict2.keys)
        
        // Log missing keys
        if keys1 != keys2 {
            let missingInDict2 = keys1.subtracting(keys2)
            if !missingInDict2.isEmpty {
                print("Keys in dict1 but missing in dict2: \(missingInDict2.sorted())")
            }
            
            let missingInDict1 = keys2.subtracting(keys1)
            if !missingInDict1.isEmpty {
                print("Keys in dict2 but missing in dict1: \(missingInDict1.sorted())")
            }
        }
        
        // Log different values
        for key in keys1.intersection(keys2) {
            let value1 = dict1[key]
            let value2 = dict2[key]
            
            // Skip checking certain keys based on options
            if options.contains(.ignoreTimestamps) && isTimestampField(key) {
                continue
            }
            if options.contains(.ignoreIds) && isIdField(key) {
                continue
            }
            if options.contains(.ignoreNulls) && (value1 == nil || value2 == nil) {
                continue
            }
            
            // Handle different value types
            if let dict1Value = value1 as? [String: Any], let dict2Value = value2 as? [String: Any] {
                if !areEqual(dict1Value, dict2Value, options: options) {
                    print("Different values for key \(key):")
                    logDifferences(dict1Value, dict2Value, options: options)
                }
            } else if let array1 = value1 as? [Any], let array2 = value2 as? [Any] {
                if !areArraysEqual(array1, array2, options: options) {
                    print("Different arrays for key \(key):")
                    print("  Array1: \(array1)")
                    print("  Array2: \(array2)")
                }
            } else if !areValuesEqual(value1, value2) {
                print("Different values for key \(key):")
                print("  Value1: \(String(describing: value1))")
                print("  Value2: \(String(describing: value2))")
            }
        }
    }
    
    /// Converts comparison options to a human-readable string
    /// - Parameter options: The options to describe
    /// - Returns: A string describing the options
    private func describeOptions(_ options: ComparisonOptions) -> String {
        var parts: [String] = []
        
        if options.contains(.ignoreTimestamps) { parts.append("ignoreTimestamps") }
        if options.contains(.ignoreIds) { parts.append("ignoreIds") }
        if options.contains(.ignoreNulls) { parts.append("ignoreNulls") }
        if options.contains(.keysOnly) { parts.append("keysOnly") }
        if options.contains(.ignoreArrayOrder) { parts.append("ignoreArrayOrder") }
        
        return parts.isEmpty ? "default" : parts.joined(separator: ", ")
    }
} 
