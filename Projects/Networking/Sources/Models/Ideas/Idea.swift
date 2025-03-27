import Core
import Foundation

public struct Idea: Identifiable, Decodable, Sendable {
    public let id: UUID
    public let imageUrl: URL?
    public let title: String
    public let category: String
    public let summary: String
    public let fullDetails: String?
    public let createdAt: Date
    public let report: Report?
    public let ethics: Ethics?
    public let techStack: [TechStackComponent]?
    public let validationMetrics: ValidationMetrics?

    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "image_url"
        case title
        case category
        case summary
        case fullDetails = "full_details"
        case createdAt = "created_at"
        case report
        case ethics
        case techStack = "tech_stack"
        case validationMetrics = "validation_metrics"
    }

    init(
        id: UUID,
        title: String,
        imageUrl: URL? = nil,
        category: String,
        summary: String,
        fullDetails: String? = nil,
        createdAt: Date,
        report: Report? = nil,
        ethics: Ethics? = nil,
        techStack: [TechStackComponent]? = nil,
        validationMetrics: ValidationMetrics? = nil
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
        self.category = category
        self.summary = summary
        self.fullDetails = fullDetails
        self.createdAt = createdAt
        self.report = report
        self.ethics = ethics
        self.techStack = techStack
        self.validationMetrics = validationMetrics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(String.self, forKey: .category)
        summary = try container.decode(String.self, forKey: .summary)
        fullDetails = try container.decodeIfPresent(String.self, forKey: .fullDetails)
        report = try container.decodeIfPresent(Report.self, forKey: .report)
        ethics = try container.decodeIfPresent(Ethics.self, forKey: .ethics)
        techStack = try container.decodeIfPresent([TechStackComponent].self, forKey: .techStack)
        validationMetrics = try container.decodeIfPresent(ValidationMetrics.self, forKey: .validationMetrics)

        let dateString = try container.decode(String.self, forKey: .createdAt)
        guard let date = DateFormatter.server.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .createdAt,
                in: container,
                debugDescription: "Date string does not match expected format"
            )
        }
        createdAt = date
    }
}

// MARK: - Preview & Mocks

#if DEBUG
    public extension Idea {
        static var mock: Idea {
            Idea(
                id: UUID(),
                title: "AI-powered Pet Grooming Service",
                imageUrl: URL(string: "https://plus.unsplash.com/premium_vector-1723293057897-2c3aa2aa49c4?q=80&w=1800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!,
                category: "Pet Care",
                summary: "An on-demand mobile app connecting pet owners with AI-assisted grooming robots.",
                fullDetails: "This innovative service combines the convenience of mobile apps with cutting-edge AI and robotics to revolutionize pet grooming. Users can schedule appointments, customize grooming preferences, and receive real-time updates during the grooming process. The AI-powered robots ensure consistent, high-quality grooming while minimizing stress for pets.",
                createdAt: Date(),
                report: Report(
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
                ),
                ethics: Ethics(
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
                ),
                techStack: [
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
                ],
                validationMetrics: ValidationMetrics(
                    prelaunchSignups: 2500,
                    pilotConversionRate: "32%",
                    earlyAdopterSegments: [
                        EarlyAdopterSegment(group: "Urban Professionals", percentage: "45%"),
                        EarlyAdopterSegment(group: "Tech Enthusiasts", percentage: "30%"),
                        EarlyAdopterSegment(group: "Pet Influencers", percentage: "15%"),
                        EarlyAdopterSegment(group: "Others", percentage: "10%"),
                    ]
                )
            )
        }
    }
#endif
