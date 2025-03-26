import ProjectDescription
import ProjectDescriptionHelpers

let project = appFrameworkProject(
    name: "Networking",
    product: .framework,
    dependencies: [
        .project(target: "Core", path: "../Core"),
    ]
)
