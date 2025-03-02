import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "AppResources",
    targets: [
        .target(
            name: "AppResources",
            destinations: destinations,
            product: .framework,
            bundleId: sharedBundleId + ".Resources",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**"],
            resources: ["Resources/**"]
        ),
    ]
)
