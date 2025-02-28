import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "UI",
    targets: [
        .target(
            name: "UI",
            destinations: destinations,
            product: .framework,
            bundleId: sharedBundleId + ".UI",
            deploymentTargets: deploymentTargets,
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
