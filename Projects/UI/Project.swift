import ProjectDescription
import ProjectDescriptionHelpers

let project = appFrameworkProject(
    name: "UI",
    dependencies: [
        .project(target: "AppResources", path: "../AppResources"),
        .project(target: "Dependencies", path: "../Dependencies"),
        .project(target: "Core", path: "../Core"),
        .project(target: "Networking", path: "../Networking")
    ]
)
