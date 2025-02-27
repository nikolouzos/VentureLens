import Core
import Foundation
import SwiftUI

final class LaunchAnimationCommand: Command {
    var hasFinishedLaunching: Binding<Bool>
    let animationDuration: Double
    
    init(hasFinishedLaunching: Binding<Bool>, animationDuration: Double) {
        self.hasFinishedLaunching = hasFinishedLaunching
        self.animationDuration = animationDuration
    }
    
    func execute() async throws {
        await MainActor.run {
            hasFinishedLaunching.wrappedValue = true
        }
        
        try? await Task.sleep(for: .seconds(animationDuration))
    }
}
