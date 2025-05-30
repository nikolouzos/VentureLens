import ProjectDescription
import ProjectDescriptionHelpers

let swiftFormatScript: TargetScript = .pre(
    path: .relativeToRoot("Scripts/swiftformat.sh"),
    name: "Run SwiftFormat"
)

let appEntitlements = Entitlements.dictionary([
    "com.apple.developer.applesignin": .array([
        .string("Default")
    ]),
    "com.apple.developer.icloud-container-identifiers": .array([
        .string("iCloud.\(sharedBundleId).UserData")
    ]),
    "com.apple.developer.icloud-services": .array([
        .string("CloudKit")
    ]),
    "aps-environment": .string("development")
])

let infoPlistExtensions: [String : ProjectDescription.Plist.Value] = [
    "ITSAppUsesNonExemptEncryption": .boolean(false),
    "UIBackgroundModes": .array([
        .string("remote-notification")
    ])
]

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: destinations,
            product: .app,
            bundleId: sharedBundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: infoPlistExtensions),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: appEntitlements,
            scripts: [
                swiftFormatScript,
            ],
            dependencies: [
                .project(target: "AppResources", path: "../AppResources"),
                .project(target: "Core", path: "../Core"),
                .project(target: "Dependencies", path: "../Dependencies"),
                .project(target: "UI", path: "../UI"),
            ],
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug", xcconfig: "../../xcconfigs/AppDebug.xcconfig"),
                    .release(name: "Release", xcconfig: "../../xcconfigs/AppRelease.xcconfig")
                ]
            )
        ),
        .target(
            name: "AppTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: sharedBundleId + "Tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "App"),
            ],
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug", xcconfig: "../../xcconfigs/Test.xcconfig"),
                    .release(name: "Release", xcconfig: "../../xcconfigs/Test.xcconfig")
                ]
            )
        ),
    ]
)
