import ProjectDescription

public func appFrameworkProject(
    name: String,
    product: Product = .staticFramework,
    includeTests: Bool = false,
    includeTestHelpers: Bool = false,
    includeResources: Bool = false,
    infoPlist: InfoPlist = .default,
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    testHelpersDependencies: [TargetDependency] = []
) -> Project {
    var targets: [Target] = [
        .target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: sharedBundleId + ".\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: includeResources
            ? ["Resources/**"]
            : nil,
            dependencies: dependencies,
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug", xcconfig: .relativeToRoot("xcconfigs/Debug.xcconfig")),
                    .release(name: "Release", xcconfig: .relativeToRoot("xcconfigs/Release.xcconfig"))
                ]
            )
        )
    ]
    
    if includeTestHelpers {
        targets.append(
            contentsOf: testTargetWithTestHelpers(
                for: name,
                testDependencies: testDependencies,
                testHelpersDependencies: testHelpersDependencies
            )
        )
    } else if includeTests {
        targets.append(
            testTarget(
                for: name,
                dependencies: testDependencies
            )
        )
    }
    
    // Create schemes
    var schemes: [Scheme] = [
        .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(
                targets: [
                    .target(name)
                ]
            ),
            testAction: includeTests || includeTestHelpers 
                ? .targets([
                    .testableTarget(
                        target: .target("\(name)Tests")
                    )
                ])
                : nil
        )
    ]
    
    return Project(
        name: name,
        targets: targets,
        schemes: schemes
    )
}
