import ProjectDescription

let bundleIdentifier = "com.genoch.VentureLens.Resources"

let project = Project(
    name: "AppResources",
    targets: [
        .target(
            name: "AppResources",
            destinations: .iOS,
            product: .framework,
            bundleId: bundleIdentifier,
            sources: ["Sources/**"],
            resources: ["Resources/**"]
        ),
    ],
    additionalFiles: [
        "Project.swift",
    ]
)
