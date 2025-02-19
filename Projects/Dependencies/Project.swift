import ProjectDescription

let bundleIdentifier = "com.genoch.IdeaForge.Dependencies"

let project = Project(
    name: "Dependencies",
    targets: [
        .target(
            name: "Dependencies",
            destinations: .iOS,
            product: .framework,
            bundleId: bundleIdentifier,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Networking", path: "../Networking"),
                .external(name: "Supabase"),
            ]
        ),
    ],
    additionalFiles: [
        "Project.swift",
    ]
)
