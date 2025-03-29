import Foundation
import XCTest

/// A set of utilities for testing asynchronous code
public enum AsyncTestHelpers {
    /// Waits for the specified condition to be true, with a timeout
    /// - Parameters:
    ///   - timeout: The maximum time to wait, in seconds
    ///   - interval: The interval at which to check the condition
    ///   - description: A description of what we're waiting for (for debugging)
    ///   - condition: The condition to check
    /// - Throws: XCTestError.timeoutWhileWaiting if the condition is not met within the timeout
    public static func wait(
        timeout: TimeInterval = 1.0,
        interval: TimeInterval = 0.01,
        description: String = "condition to be true",
        condition: @escaping () -> Bool
    ) async throws {
        let endTime = Date().addingTimeInterval(timeout)
        
        while !condition() {
            if Date() >= endTime {
                throw XCTestError(.timeoutWhileWaiting, userInfo: [
                    NSLocalizedDescriptionKey: "Timed out waiting for \(description)"
                ])
            }
            
            try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
        }
    }
    
    /// Runs the provided work in a task, with a timeout
    /// - Parameters:
    ///   - timeout: The maximum time to wait for the work to complete
    ///   - description: A description of the work (for debugging)
    ///   - work: The async work to perform
    /// - Returns: The result of the work
    /// - Throws: XCTestError.timeoutWhileWaiting if the work does not complete within the timeout
    public static func withTimeout<T>(
        _ timeout: TimeInterval = 1.0,
        description: String = "operation to complete",
        work: @escaping () async throws -> T
    ) async throws -> T {
        // Create a Task for the work
        let workTask = Task {
            try await work()
        }
        
        // Create a separate task for the timeout
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
            return true // True means we timed out
        }
        
        // Wait for either task to complete
        let timedOut = await timeoutTask.result.flatMapError { (_) -> Result<Bool, Never> in return .success(false) }.get()
        
        if timedOut {
            // Cancel the work task
            workTask.cancel()
            
            throw XCTestError(.timeoutWhileWaiting, userInfo: [
                NSLocalizedDescriptionKey: "Timed out waiting for \(description)"
            ])
        }
        
        // Get the result from the work task
        return try await workTask.value
    }
    
    /// Runs multiple tasks concurrently and waits for all to complete
    /// - Parameter tasks: The async work to perform
    /// - Returns: An array of results, in the same order as the tasks
    public static func runConcurrently<T>(
        _ tasks: [() async throws -> T]
    ) async throws -> [T] {
        // Create the Task.Group to run all tasks
        try await withThrowingTaskGroup(of: (Int, T).self) { group in
            // Add all tasks to the group with their index
            for (index, task) in tasks.enumerated() {
                group.addTask {
                    let result = try await task()
                    return (index, result)
                }
            }
            
            // Collect the results in the correct order
            var results = [T?](repeating: nil, count: tasks.count)
            
            for try await (index, result) in group {
                results[index] = result
            }
            
            // Unwrap all results (they should all be non-nil at this point)
            return results.compactMap { $0 }
        }
    }
    
    /// Executes the given block and verifies that a specific error is thrown
    /// - Parameters:
    ///   - expectedError: The type of error expected
    ///   - block: The code to execute
    public static func assertThrowsAsync<T, E: Error & Equatable>(
        _ expectedError: E,
        _ block: @escaping () async throws -> T
    ) async {
        do {
            let _ = try await block()
            XCTFail("Expected \(expectedError) but no error was thrown")
        } catch let error as E {
            XCTAssertEqual(error, expectedError, "Expected \(expectedError) but got \(error)")
        } catch {
            XCTFail("Expected \(expectedError) but got \(error)")
        }
    }
    
    /// Executes the given block and verifies that a specific error type is thrown
    /// - Parameters:
    ///   - expectedErrorType: The type of error expected
    ///   - block: The code to execute
    public static func assertThrowsErrorTypeAsync<T, E: Error>(
        _ expectedErrorType: E.Type,
        _ block: @escaping () async throws -> T
    ) async {
        do {
            let _ = try await block()
            XCTFail("Expected error of type \(expectedErrorType) but no error was thrown")
        } catch let error as E {
            // Success - we got the expected error type
        } catch {
            XCTFail("Expected error of type \(expectedErrorType) but got \(error)")
        }
    }
} 
