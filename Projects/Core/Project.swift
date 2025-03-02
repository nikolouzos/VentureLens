import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Core",
    targets: [
        .target(
            name: "Core",
            destinations: destinations,
            product: .framework,
            bundleId: sharedBundleId + ".Core",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**"]
        ),
    ]
)
