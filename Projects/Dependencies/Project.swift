import ProjectDescription
import ProjectDescriptionHelpers

let project = appFrameworkProject(
    name: "Dependencies",
    product: .framework,
    includeTestHelpers: true,
    infoPlist: .extendingDefault(with: [
        "SUPABASE_URL": Plist.Value(stringLiteral: supabaseUrl()),
        "SUPABASE_KEY": Plist.Value(stringLiteral: supabaseKey()),
        "MIXPANEL_TOKEN": Plist.Value(stringLiteral: mixpanelToken())
    ]),
    dependencies: [
        .project(target: "Networking", path: "../Networking"),
        .external(name: "Mixpanel"),
        .external(name: "Supabase")
    ],
    testDependencies: [
        .project(target: "Networking", path: "../Networking")
    ],
    testHelpersDependencies: [
        .project(target: "Networking", path: "../Networking")
    ]
)
