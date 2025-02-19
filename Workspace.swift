import ProjectDescription

let workspace = Workspace(
    name: "IdeaForge",
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
