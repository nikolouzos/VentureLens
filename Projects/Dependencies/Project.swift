import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Dependencies",
    targets: [
        .target(
            name: "Dependencies",
            destinations: destinations,
            product: .framework,
            bundleId: sharedBundleId + ".Dependencies",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: [
                "SUPABASE_URL": Plist.Value(stringLiteral: supabaseUrl()),
                "SUPABASE_KEY": Plist.Value(stringLiteral: supabaseKey())
            ]),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Networking", path: "../Networking"),
                .external(name: "Supabase"),
            ]
        ),
        .target(
            name: "DependenciesTestHelpers",
            destinations: destinations,
            product: .framework,
            bundleId: sharedBundleId + ".DependenciesTestHelpers",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["TestHelpers/**"],
            dependencies: [
                .target(name: "Dependencies"),
                .project(target: "Networking", path: "../Networking")
            ]
        ),
        .target(
            name: "DependenciesTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: sharedBundleId + ".DependenciesTests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Dependencies"),
                .target(name: "DependenciesTestHelpers"),
                .project(target: "Networking", path: "../Networking")
            ]
        ),
    ]
)
