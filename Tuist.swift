import ProjectDescription

let tuist = Tuist(
    project: .tuist(
        compatibleXcodeVersions: .upToNextMajor(
            Version(16, 0, 0)
        ),
        swiftVersion: Version(6, 0, 0)
    )
)
