import Networking
import SwiftUI

/// Provides mock Idea objects for SwiftUI previews
public enum IdeaPreviews {
    /// A standard idea with all fields populated
    public static var standard: Idea {
        Idea(
            id: UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!,
            title: "AI-powered Pet Grooming Service",
            imageUrl: URL(string: "https://plus.unsplash.com/premium_vector-1723293057897-2c3aa2aa49c4?q=80&w=1800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!,
            category: "Pet Care",
            summary: "An on-demand mobile app connecting pet owners with AI-assisted grooming robots.",
            fullDetails: "This innovative service combines the convenience of mobile apps with cutting-edge AI and robotics to revolutionize pet grooming. Users can schedule appointments, customize grooming preferences, and receive real-time updates during the grooming process. The AI-powered robots ensure consistent, high-quality grooming while minimizing stress for pets.",
            createdAt: Date(),
            report: createStandardReport(),
            ethics: createStandardEthics(),
            techStack: createStandardTechStack(),
            validationMetrics: createStandardValidationMetrics()
        )
    }

    /// A minimal idea with only required fields
    public static var minimal: Idea {
        Idea(
            id: UUID(uuidString: "a63b5f8c-1d2e-3f4a-5b6c-7d8e9f0a1b2c")!,
            title: "Minimal Idea",
            category: "Technology",
            summary: "A basic idea with minimal information",
            createdAt: Date()
        )
    }

    /// An idea with specific report data
    public static var withReport: Idea {
        let idea = minimal
        return Idea(
            id: idea.id,
            title: idea.title,
            imageUrl: idea.imageUrl,
            category: idea.category,
            summary: idea.summary,
            fullDetails: idea.fullDetails,
            createdAt: idea.createdAt,
            report: createStandardReport(),
            ethics: idea.ethics,
            techStack: idea.techStack,
            validationMetrics: idea.validationMetrics
        )
    }

    /// An idea with ethics information
    public static var withEthics: Idea {
        let idea = minimal
        return Idea(
            id: idea.id,
            title: idea.title,
            imageUrl: idea.imageUrl,
            category: idea.category,
            summary: idea.summary,
            fullDetails: idea.fullDetails,
            createdAt: idea.createdAt,
            report: idea.report,
            ethics: createStandardEthics(),
            techStack: idea.techStack,
            validationMetrics: idea.validationMetrics
        )
    }

    /// An array of sample ideas for list previews
    public static var samples: [Idea] {
        [
            standard,
            minimal,
            Idea(
                id: UUID(uuidString: "b63b5f8c-1d2e-3f4a-5b6c-7d8e9f0a1b2c")!,
                title: "Fintech App",
                category: "Fintech",
                summary: "A financial technology solution",
                createdAt: Date()
            ),
            withReport,
            withEthics,
        ]
    }

    // MARK: - Private Helpers

    private static func createStandardReport() -> Report {
        Report(
            competitors: [
                Competitor(
                    name: "PetSmart",
                    weakness: "Traditional brick-and-mortar model with limited tech integration",
                    differentiator: "Fully automated AI-driven grooming with no human intervention needed"
                ),
                Competitor(name: "Petco",
                           weakness: "High prices and inconsistent quality across locations",
                           differentiator: "Standardized quality and algorithmic pricing based on pet needs"),
            ],
            financials: Financials(
                totalYear1Costs: 500_000,
                totalYear1Revenue: 1_200_000,
                startupCosts: StartupCosts(
                    development: 300_000,
                    marketing: 150_000,
                    compliance: 50000
                ),
                projections: Projections(
                    year1: 1_200_000,
                    year2: 3_500_000,
                    year3: 7_800_000
                ),
                fundingAdvice: [
                    "Seek seed funding of at least $750K",
                    "Consider strategic partnerships with established pet care brands",
                ],
                unitEconomics: UnitEconomics(
                    cac: 120,
                    ltv: 840,
                    paybackPeriodMonths: 6
                )
            ),
            market: Market(
                tam: TAM(
                    value: 4_500_000_000,
                    segments: Segments(
                        geography: ["North America", "Europe"],
                        productType: ["Mobile Grooming", "Subscription Services"]
                    )
                ),
                growthRate: GrowthRate(
                    value: "12.5% CAGR",
                    timeframe: "2023-2028",
                    drivers: [
                        "Increasing pet ownership among millennials",
                        "Growing demand for convenience services",
                    ]
                ),
                demographics: [
                    Demographic(
                        segment: "Urban Pet Owners",
                        behavior: "Time-constrained professionals willing to pay premium for convenience",
                        source: "Pet Industry Market Report 2023"
                    ),
                ]
            ),
            roadmap: [
                RoadmapPhase(
                    phase: "MVP Development",
                    timelineMonths: 4,
                    milestones: [
                        "Develop AI grooming algorithm prototype",
                        "Create basic mobile app with appointment scheduling",
                    ]
                ),
                RoadmapPhase(
                    phase: "Beta Launch",
                    timelineMonths: 3,
                    milestones: [
                        "Deploy 10 robot units in test market",
                        "Onboard 100 beta users",
                    ]
                ),
            ]
        )
    }

    private static func createStandardEthics() -> Ethics {
        Ethics(
            risks: [
                Risk(
                    type: "Pet Safety",
                    description: "Potential for injury if AI misidentifies pet characteristics or movements",
                    severity: "High"
                ),
                Risk(
                    type: "Data Privacy",
                    description: "Collection of pet and owner data raises privacy concerns",
                    severity: "Medium"
                ),
            ],
            mitigations: [
                "Implement comprehensive safety protocols with multiple fail-safes",
                "Develop clear data privacy policy with opt-out options",
            ]
        )
    }

    private static func createStandardTechStack() -> [TechStackComponent] {
        [
            TechStackComponent(
                component: "Mobile App",
                tools: ["Swift", "SwiftUI", "Firebase", "Stripe API"]
            ),
            TechStackComponent(
                component: "AI & Machine Learning",
                tools: ["TensorFlow", "PyTorch", "Computer Vision APIs"]
            ),
        ]
    }

    private static func createStandardValidationMetrics() -> ValidationMetrics {
        ValidationMetrics(
            prelaunchSignups: 2500,
            pilotConversionRate: "32%",
            earlyAdopterSegments: [
                EarlyAdopterSegment(group: "Urban Professionals", percentage: "45%"),
                EarlyAdopterSegment(group: "Tech Enthusiasts", percentage: "30%"),
            ]
        )
    }
}
