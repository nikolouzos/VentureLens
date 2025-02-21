import ProjectDescription

let bundleIdentifier = "com.genoch.VentureLens.Networking"

let project = Project(
    name: "Networking",
    targets: [
        .target(
            name: "Networking",
            destinations: .iOS,
            product: .framework,
            bundleId: bundleIdentifier,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Core", path: "../Core"),
            ]
        ),
    ],
    additionalFiles: [
        "Project.swift",
    ]
)
