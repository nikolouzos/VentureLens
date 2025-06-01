import Core
import Foundation
import SwiftUI

@MainActor
final class LaunchAnimationCommand: Command {
    var hasFinishedLaunching: Binding<Bool>
    let animationDuration: Double

    init(hasFinishedLaunching: Binding<Bool>, animationDuration: Double) {
        self.hasFinishedLaunching = hasFinishedLaunching
        self.animationDuration = animationDuration
    }

    func execute() async throws {
        hasFinishedLaunching.wrappedValue = true
        try? await Task.sleep(for: .seconds(animationDuration))
    }
}
