// swift-tools-version:6.1
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
        "Mixpanel": .options(automaticSchemesOptions: .disabled),
        "RevenueCat": .options(automaticSchemesOptions: .disabled)
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
        ),
        .package(
            url: "https://github.com/RevenueCat/purchases-ios-spm.git",
            .upToNextMajor(from: "5.0.0")
        )
    ]
)
