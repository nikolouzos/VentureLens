import Foundation

public struct Report: Codable, Sendable {
    public let competitors: [Competitor]?
    public let financials: Financials?
    public let market: Market?
    public let roadmap: [RoadmapPhase]?

    public init(
        competitors: [Competitor]? = nil,
        financials: Financials? = nil,
        market: Market? = nil,
        roadmap: [RoadmapPhase]? = nil
    ) {
        self.competitors = competitors
        self.financials = financials
        self.market = market
        self.roadmap = roadmap
    }

    private enum CodingKeys: String, CodingKey {
        case competitors
        case financials
        case market
        case roadmap
    }
}

public struct Competitor: Codable, Sendable {
    public let name: String
    public let weakness: String?
    public let differentiator: String?

    public init(name: String, weakness: String? = nil, differentiator: String? = nil) {
        self.name = name
        self.weakness = weakness
        self.differentiator = differentiator
    }
}

public struct Financials: Codable, Sendable {
    public let totalYear1Costs: Int?
    public let totalYear1Revenue: Int?
    public let startupCosts: StartupCosts?
    public let projections: Projections?
    public let fundingAdvice: [String]?
    public let unitEconomics: UnitEconomics?

    public init(
        totalYear1Costs: Int? = nil,
        totalYear1Revenue: Int? = nil,
        startupCosts: StartupCosts? = nil,
        projections: Projections? = nil,
        fundingAdvice: [String]? = nil,
        unitEconomics: UnitEconomics? = nil
    ) {
        self.totalYear1Costs = totalYear1Costs
        self.totalYear1Revenue = totalYear1Revenue
        self.startupCosts = startupCosts
        self.projections = projections
        self.fundingAdvice = fundingAdvice
        self.unitEconomics = unitEconomics
    }

    private enum CodingKeys: String, CodingKey {
        case totalYear1Costs = "total_year_1_costs"
        case totalYear1Revenue = "total_year_1_revenue"
        case startupCosts = "startup_costs"
        case projections
        case fundingAdvice = "funding_advice"
        case unitEconomics = "unit_economics"
    }
}

public struct StartupCosts: Codable, Sendable {
    public let development: Int?
    public let marketing: Int?
    public let compliance: Int?

    public init(development: Int? = nil, marketing: Int? = nil, compliance: Int? = nil) {
        self.development = development
        self.marketing = marketing
        self.compliance = compliance
    }
}

public struct Projections: Codable, Sendable {
    public let year1: Int?
    public let year2: Int?
    public let year3: Int?

    public init(year1: Int? = nil, year2: Int? = nil, year3: Int? = nil) {
        self.year1 = year1
        self.year2 = year2
        self.year3 = year3
    }

    private enum CodingKeys: String, CodingKey {
        case year1 = "Year1"
        case year2 = "Year2"
        case year3 = "Year3"
    }
}

public struct UnitEconomics: Codable, Sendable {
    public let cac: Int?
    public let ltv: Int?
    public let paybackPeriodMonths: Int?

    public init(cac: Int? = nil, ltv: Int? = nil, paybackPeriodMonths: Int? = nil) {
        self.cac = cac
        self.ltv = ltv
        self.paybackPeriodMonths = paybackPeriodMonths
    }

    private enum CodingKeys: String, CodingKey {
        case cac
        case ltv
        case paybackPeriodMonths = "payback_period_months"
    }
}

public struct Market: Codable, Sendable {
    public let tam: TAM?
    public let growthRate: GrowthRate?
    public let demographics: [Demographic]?

    public init(tam: TAM? = nil, growthRate: GrowthRate? = nil, demographics: [Demographic]? = nil) {
        self.tam = tam
        self.growthRate = growthRate
        self.demographics = demographics
    }

    private enum CodingKeys: String, CodingKey {
        case tam
        case growthRate = "growth_rate"
        case demographics
    }
}

public struct TAM: Codable, Sendable {
    public let value: Int?
    public let segments: Segments?

    public init(value: Int? = nil, segments: Segments? = nil) {
        self.value = value
        self.segments = segments
    }
}

public struct Segments: Codable, Sendable {
    public let geography: [String]?
    public let productType: [String]?

    public init(geography: [String]? = nil, productType: [String]? = nil) {
        self.geography = geography
        self.productType = productType
    }

    private enum CodingKeys: String, CodingKey {
        case geography
        case productType = "product_type"
    }
}

public struct GrowthRate: Codable, Sendable {
    public let value: String?
    public let timeframe: String?
    public let drivers: [String]?

    public init(value: String? = nil, timeframe: String? = nil, drivers: [String]? = nil) {
        self.value = value
        self.timeframe = timeframe
        self.drivers = drivers
    }
}

public struct Demographic: Codable, Sendable {
    public let segment: String?
    public let behavior: String?
    public let source: String?

    public init(segment: String? = nil, behavior: String? = nil, source: String? = nil) {
        self.segment = segment
        self.behavior = behavior
        self.source = source
    }
}

public struct RoadmapPhase: Codable, Sendable {
    public let phase: String?
    public let timelineMonths: Int?
    public let milestones: [String]?

    public init(phase: String? = nil, timelineMonths: Int? = nil, milestones: [String]? = nil) {
        self.phase = phase
        self.timelineMonths = timelineMonths
        self.milestones = milestones
    }

    private enum CodingKeys: String, CodingKey {
        case phase
        case timelineMonths = "timeline_months"
        case milestones
    }
}
