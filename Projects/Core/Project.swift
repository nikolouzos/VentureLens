import ProjectDescription

let bundleIdentifier = "com.genoch.VentureLens.Core"

let project = Project(
    name: "Core",
    targets: [
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: bundleIdentifier,
            sources: ["Sources/**"]
        ),
    ],
    additionalFiles: [
        "Project.swift",
    ]
)
