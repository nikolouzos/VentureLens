import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Networking",
    targets: [
        .target(
            name: "Networking",
            destinations: destinations,
            product: .framework,
            bundleId: sharedBundleId + ".Networking",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Core", path: "../Core"),
            ]
        ),
    ]
)
