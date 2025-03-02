import ProjectDescription
import ProjectDescriptionHelpers

let swiftFormatScript: TargetScript = .pre(
    path: .relativeToRoot("Scripts/swiftformat.sh"),
    name: "Run SwiftFormat"
)

let appEntitlements = Entitlements.dictionary([
    "com.apple.developer.applesignin": [
        "Default"
    ],
    "com.apple.developer.icloud-container-identifiers": [
        "iCloud.\(sharedBundleId).UserData"
    ],
    "com.apple.developer.icloud-services": [
        "CloudKit"
    ]
])

let project = Project(
    name: "App",
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "../../xcconfigs/App.xcconfig"),
        .release(name: "Release", xcconfig: "../../xcconfigs/App.xcconfig"),
    ]),
    targets: [
        .target(
            name: "App",
            destinations: destinations,
            product: .app,
            bundleId: sharedBundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: [
                "UIBackgroundModes": [
                    "remote-notification"
                ]
            ]),
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
            ]
        ),
        .target(
            name: "AppTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: sharedBundleId + "Tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "App"),
            ]
        ),
    ]
)
