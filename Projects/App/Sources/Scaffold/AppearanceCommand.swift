import AppResources
import Core
import Foundation
import UIKit

final class AppearanceCommand: Command {
    func execute() async throws {
        registerFonts()
        setTabBarAppearance()
        setNavigationBarAppearance()
    }

    private func registerFonts() {
        AppResourcesFontFamily.registerAllCustomFonts()
    }

    private func setTabBarAppearance() {
        let appearance = UITabBarItem.appearance()
        let attributes = [
            NSAttributedString.Key.font: UIFont.plusJakartaSans(.footnote, weight: .regular),
        ]
        appearance.setTitleTextAttributes(attributes, for: .normal)
    }

    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()

        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.plusJakartaSans(.title3, weight: .semibold),
        ]

        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.plusJakartaSans(.largeTitle, weight: .bold),
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
