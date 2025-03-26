import ProjectDescription

public func testTargetWithTestHelpers(
    for target: String,
    testDependencies: [TargetDependency] = [],
    testHelpersDependencies: [TargetDependency] = []
) -> [Target] {
    return [
        .target(
            name: "\(target)TestHelpers",
            destinations: destinations,
            product: .framework,
            bundleId: sharedBundleId + ".\(target)TestHelpers",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["TestHelpers/**"],
            dependencies: [
                .target(name: target)
            ] + testHelpersDependencies,
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug", xcconfig: .relativeToRoot("xcconfigs/Test.xcconfig")),
                    .release(name: "Release", xcconfig: .relativeToRoot("xcconfigs/Test.xcconfig"))
                ]
            )
        ),
        testTarget(
            for: target,
            dependencies: [
                .target(name: "\(target)TestHelpers")
            ] + testDependencies
        )
    ]
}
