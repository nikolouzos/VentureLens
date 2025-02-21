import ProjectDescription

let workspace = Workspace(
    name: "VentureLens",
    projects: [
        "Projects/**",
    ],
    additionalFiles: [
        "Tuist/**",
        "Scripts/**",
        "xcconfigs/**",
        "Workspace.swift",
        "Tuist.swift",
    ]
)
