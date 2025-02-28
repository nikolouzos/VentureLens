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
    ],
    additionalFiles: [
        "Project.swift",
    ]
)
