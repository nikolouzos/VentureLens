import ProjectDescription
import ProjectDescriptionHelpers

let project = appFrameworkProject(
    name: "Networking",
    product: .framework,
    includeTestHelpers: true,
    dependencies: [
        .project(target: "Core", path: "../Core"),
    ],
    testHelpersDependencies: [
        .xctest
    ]
)
