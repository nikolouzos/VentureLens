import ProjectDescription

let bundleIdentifier = "com.genoch.IdeaForge.UI"

let project = Project(
    name: "UI",
    targets: [
        .target(
            name: "UI",
            destinations: .iOS,
            product: .framework,
            bundleId: bundleIdentifier,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "AppResources", path: "../AppResources"),
                .project(target: "Dependencies", path: "../Dependencies"),
                .project(target: "Core", path: "../Core"),
                .project(target: "Networking", path: "../Networking"),
            ]
        ),
    ],
    additionalFiles: [
        "Project.swift",
    ]
)
