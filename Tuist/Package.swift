// swift-tools-version:5.9
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    productTypes: [
        "Mixpanel": .staticLibrary
    ],
    projectOptions: [
        "Supabase": .options(automaticSchemesOptions: .disabled),
        "Mixpanel": .options(automaticSchemesOptions: .disabled)
    ]
)
#endif

let package = Package(
    name: "VentureLens",
    dependencies: [
        .package(
            url: "https://github.com/supabase/supabase-swift.git",
            .upToNextMajor(from: "2.0.0")
        ),
        .package(
            url: "https://github.com/mixpanel/mixpanel-swift.git",
            .upToNextMajor(from: "4.3.0")
        )
    ]
)
