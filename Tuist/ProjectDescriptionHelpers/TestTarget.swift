import ProjectDescription

public func testTarget(
    for target: String,
    dependencies: [TargetDependency] = []
) -> Target {
    .target(
        name: "\(target)Tests",
        destinations: destinations,
        product: .unitTests,
        bundleId: sharedBundleId + ".\(target)Tests",
        deploymentTargets: deploymentTargets,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [
            .target(name: target),
            .xctest
        ] + dependencies,
        settings: .settings(
            base: [:],
            configurations: [
                .debug(name: "Debug", xcconfig: .relativeToRoot("xcconfigs/Test.xcconfig")),
                .release(name: "Release", xcconfig: .relativeToRoot("xcconfigs/Test.xcconfig"))
            ]
        )
    )
}
