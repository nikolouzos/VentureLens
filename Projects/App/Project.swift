import ProjectDescription

let bundleIdentifier = "com.genoch.VentureLens"

let swiftFormatScript: TargetScript = .pre(
    path: .relativeToRoot("Scripts/swiftformat.sh"),
    name: "Run SwiftFormat"
)

let project = Project(
    name: "App",
    settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "../../xcconfigs/App.xcconfig"),
        .release(name: "Release", xcconfig: "../../xcconfigs/App.xcconfig"),
    ]),
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: bundleIdentifier,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
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
            destinations: .iOS,
            product: .unitTests,
            bundleId: bundleIdentifier + "Tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "App"),
            ]
        ),
    ],
    additionalFiles: [
        "Project.swift",
    ]
)
