import Foundation
@testable import Networking

/// Provides predefined Idea objects for testing
public enum IdeaFixtures {
    
    /// Returns a standard test idea with all fields populated
    public static func standard() -> Idea {
        return Idea(
            id: UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!,
            title: "AI-powered Pet Grooming Service",
            imageUrl: URL(string: "https://plus.unsplash.com/premium_vector-1723293057897-2c3aa2aa49c4?q=80&w=1800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!,
            category: "Pet Care",
            summary: "An on-demand mobile app connecting pet owners with AI-assisted grooming robots.",
            fullDetails: "This innovative service combines the convenience of mobile apps with cutting-edge AI and robotics to revolutionize pet grooming. Users can schedule appointments, customize grooming preferences, and receive real-time updates during the grooming process. The AI-powered robots ensure consistent, high-quality grooming while minimizing stress for pets.",
            createdAt: Date(timeIntervalSince1970: 1623456789),
            report: createStandardReport(),
            ethics: createStandardEthics(),
            techStack: createStandardTechStack(),
            validationMetrics: createStandardValidationMetrics()
        )
    }
    
    /// Returns a minimal idea with only required fields
    public static func minimal() -> Idea {
        return Idea(
            id: UUID(uuidString: "a63b5f8c-1d2e-3f4a-5b6c-7d8e9f0a1b2c")!,
            title: "Minimal Idea",
            category: "Technology",
            summary: "A basic idea with minimal information",
            createdAt: Date(timeIntervalSince1970: 1623456789)
        )
    }
    
    /// Returns an idea with a specific category
    public static func withCategory(_ category: String) -> Idea {
        let idea = minimal()
        return Idea(
            id: idea.id,
            title: idea.title,
            imageUrl: idea.imageUrl,
            category: category,
            summary: idea.summary,
            fullDetails: idea.fullDetails,
            createdAt: idea.createdAt,
            report: idea.report,
            ethics: idea.ethics,
            techStack: idea.techStack,
            validationMetrics: idea.validationMetrics
        )
    }
    
    /// Returns an idea with specific report data
    public static func withReport() -> Idea {
        var idea = minimal()
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
    
    /// Returns an idea with ethics information
    public static func withEthics() -> Idea {
        let idea = minimal()
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
    
    // MARK: - Private Helpers
    
    private static func createStandardReport() -> Report {
        return Report(
            competitors: [
                Competitor(
                    name: "PetSmart",
                    weakness: "Traditional brick-and-mortar model with limited tech integration",
                    differentiator: "Fully automated AI-driven grooming with no human intervention needed"
                ),
                Competitor(
                    name: "Petco",
                    weakness: "High prices and inconsistent quality across locations",
                    differentiator: "Standardized quality and algorithmic pricing based on pet needs"
                ),
                Competitor(
                    name: "Mobile Groomers",
                    weakness: "Limited availability and scheduling difficulties",
                    differentiator: "On-demand service with 24/7 availability and instant booking"
                ),
                Competitor(
                    name: "DIY Pet Washing Stations",
                    weakness: "Requires pet owner effort and expertise",
                    differentiator: "Zero effort required from pet owners with better results"
                ),
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
                    "Prepare for Series A within 18 months of launch",
                    "Explore pet industry-specific VCs for better terms",
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
                        geography: ["North America", "Europe", "Asia Pacific", "Latin America"],
                        productType: ["Mobile Grooming", "Subscription Services", "Premium Pet Care"]
                    )
                ),
                growthRate: GrowthRate(
                    value: "12.5% CAGR",
                    timeframe: "2023-2028",
                    drivers: [
                        "Increasing pet ownership among millennials",
                        "Growing demand for convenience services",
                        "Rising pet care expenditure per household",
                        "Adoption of smart home and IoT technologies",
                    ]
                ),
                demographics: [
                    Demographic(
                        segment: "Urban Pet Owners",
                        behavior: "Time-constrained professionals willing to pay premium for convenience",
                        source: "Pet Industry Market Report 2023"
                    ),
                    Demographic(
                        segment: "Tech-Savvy Pet Parents",
                        behavior: "Early adopters of pet tech and smart home devices",
                        source: "Consumer Trends Analysis"
                    ),
                    Demographic(
                        segment: "Luxury Pet Services Customers",
                        behavior: "High disposable income spent on premium pet experiences",
                        source: "Market Segmentation Study"
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
                        "Build first robot prototype with essential grooming functions",
                        "Conduct initial safety and effectiveness testing",
                        "Establish secure payment processing system",
                    ]
                ),
                RoadmapPhase(
                    phase: "Beta Launch",
                    timelineMonths: 3,
                    milestones: [
                        "Deploy 10 robot units in test market",
                        "Onboard 100 beta users",
                        "Implement feedback collection system",
                        "Refine AI algorithms based on initial usage data",
                        "Optimize mobile app UX based on user testing",
                    ]
                ),
                RoadmapPhase(
                    phase: "Market Expansion",
                    timelineMonths: 6,
                    milestones: [
                        "Scale to 3 major metropolitan areas",
                        "Produce 50 additional robot units",
                        "Implement subscription pricing model",
                        "Launch marketing campaign targeting urban pet owners",
                        "Develop partnerships with pet supply retailers",
                    ]
                ),
                RoadmapPhase(
                    phase: "Feature Enhancement",
                    timelineMonths: 5,
                    milestones: [
                        "Add specialized grooming options for different breeds",
                        "Implement pet health monitoring features",
                        "Develop integration with smart home systems",
                        "Create loyalty and referral program",
                        "Launch premium service tier with additional features",
                    ]
                ),
            ]
        )
    }
    
    private static func createStandardEthics() -> Ethics {
        return Ethics(
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
                Risk(
                    type: "Job Displacement",
                    description: "Technology may reduce employment for traditional pet groomers",
                    severity: "Medium"
                ),
                Risk(
                    type: "Algorithmic Bias",
                    description: "AI may not perform equally well across all pet breeds and types",
                    severity: "High"
                ),
            ],
            mitigations: [
                "Implement comprehensive safety protocols with multiple fail-safes",
                "Develop clear data privacy policy with opt-out options",
                "Create reskilling program for traditional groomers to work with the technology",
                "Ensure diverse training data across pet breeds, sizes, and coat types",
                "Regular third-party safety and ethics audits",
            ]
        )
    }
    
    private static func createStandardTechStack() -> [TechStackComponent] {
        return [
            TechStackComponent(
                component: "Mobile App",
                tools: ["Swift", "SwiftUI", "Firebase", "Stripe API"]
            ),
            TechStackComponent(
                component: "AI & Machine Learning",
                tools: ["TensorFlow", "PyTorch", "Computer Vision APIs", "Custom Neural Networks"]
            ),
            TechStackComponent(
                component: "Robotics",
                tools: ["ROS (Robot Operating System)", "Custom Firmware", "Sensor Integration", "Actuator Control Systems"]
            ),
            TechStackComponent(
                component: "Backend",
                tools: ["Node.js", "Express", "MongoDB", "AWS Lambda"]
            ),
            TechStackComponent(
                component: "DevOps",
                tools: ["Docker", "Kubernetes", "CI/CD Pipeline", "AWS"]
            ),
        ]
    }
    
    private static func createStandardValidationMetrics() -> ValidationMetrics {
        return ValidationMetrics(
            prelaunchSignups: 2500,
            pilotConversionRate: "32%",
            earlyAdopterSegments: [
                EarlyAdopterSegment(group: "Urban Professionals", percentage: "45%"),
                EarlyAdopterSegment(group: "Tech Enthusiasts", percentage: "30%"),
                EarlyAdopterSegment(group: "Pet Influencers", percentage: "15%"),
                EarlyAdopterSegment(group: "Others", percentage: "10%"),
            ]
        )
    }
}

/// Builder for creating custom Idea instances for testing
public class IdeaBuilder {
    private var id: UUID = UUID(uuidString: "48b3ebc4-039b-42b1-b676-51f5616fe1fb")!
    private var title: String = "Test Idea"
    private var imageUrl: URL? = nil
    private var category: String = "Test Category"
    private var summary: String = "This is a test idea summary"
    private var fullDetails: String? = nil
    private var createdAt: Date = Date()
    private var report: Report? = nil
    private var ethics: Ethics? = nil
    private var techStack: [TechStackComponent]? = nil
    private var validationMetrics: ValidationMetrics? = nil
    
    /// Creates a new idea builder
    public init() {}
    
    /// Sets the idea ID
    public func withId(_ id: UUID) -> IdeaBuilder {
        self.id = id
        return self
    }
    
    /// Sets the idea title
    public func withTitle(_ title: String) -> IdeaBuilder {
        self.title = title
        return self
    }
    
    /// Sets the idea image URL
    public func withImageUrl(_ imageUrl: URL?) -> IdeaBuilder {
        self.imageUrl = imageUrl
        return self
    }
    
    /// Sets the idea category
    public func withCategory(_ category: String) -> IdeaBuilder {
        self.category = category
        return self
    }
    
    /// Sets the idea summary
    public func withSummary(_ summary: String) -> IdeaBuilder {
        self.summary = summary
        return self
    }
    
    /// Sets the idea full details
    public func withFullDetails(_ fullDetails: String?) -> IdeaBuilder {
        self.fullDetails = fullDetails
        return self
    }
    
    /// Sets the idea creation date
    public func withCreatedAt(_ createdAt: Date) -> IdeaBuilder {
        self.createdAt = createdAt
        return self
    }
    
    /// Sets the idea report
    public func withReport(_ report: Report?) -> IdeaBuilder {
        self.report = report
        return self
    }
    
    /// Sets the idea ethics
    public func withEthics(_ ethics: Ethics?) -> IdeaBuilder {
        self.ethics = ethics
        return self
    }
    
    /// Sets the idea tech stack
    public func withTechStack(_ techStack: [TechStackComponent]?) -> IdeaBuilder {
        self.techStack = techStack
        return self
    }
    
    /// Sets the idea validation metrics
    public func withValidationMetrics(_ validationMetrics: ValidationMetrics?) -> IdeaBuilder {
        self.validationMetrics = validationMetrics
        return self
    }
    
    /// Builds the idea with the configured properties
    public func build() -> Idea {
        return Idea(
            id: id,
            title: title,
            imageUrl: imageUrl,
            category: category,
            summary: summary,
            fullDetails: fullDetails,
            createdAt: createdAt,
            report: report,
            ethics: ethics,
            techStack: techStack,
            validationMetrics: validationMetrics
        )
    }
} 