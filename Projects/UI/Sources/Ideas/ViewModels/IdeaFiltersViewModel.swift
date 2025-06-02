import Foundation
import Networking
import SwiftUI

public final class IdeaFiltersViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var category: String = ""
    @Published var createdBeforeDate = Date()
    @Published var createdAfterDate = Date()

    private let onApplyFilters: (
        _ searchQuery: String?,
        _ category: String?,
        _ createdBeforeTimestamp: String?,
        _ createdAfterTimestamp: String?
    ) -> Void
    private let dateFormatter: DateFormatter
    private let filters: IdeasFiltersResponse

    var availableCategories: [String] {
        filters.categories
    }

    var fromDateRange: ClosedRange<Date> {
        filters.minDate ... createdBeforeDate
    }

    var toDateRange: ClosedRange<Date> {
        createdAfterDate ... filters.maxDate
    }

    public init(
        currentRequest: IdeasListRequest,
        filters: IdeasFiltersResponse,
        onApplyFilters: @escaping (
            _ searchQuery: String?,
            _ category: String?,
            _ createdBefore: String?,
            _ createdAfter: String?
        ) -> Void
    ) {
        guard case let .filters(
            currentQuery,
            currentCategory,
            currentCreatedBefore,
            currentCreatedAfter
        ) = currentRequest.requestType else {
            preconditionFailure("\(Self.self) cannot be initialized with incorrect IdeasListRequest.RequestType")
        }

        self.onApplyFilters = onApplyFilters
        self.filters = filters

        dateFormatter = .server

        query = currentQuery ?? ""
        category = currentCategory ?? ""

        // Initialize dates in correct order
        createdAfterDate = filters.minDate
        createdBeforeDate = filters.maxDate

        // Then try to apply current filter values if they exist
        if let createdAfter = currentCreatedAfter,
           let date = dateFormatter.date(from: createdAfter)
        {
            createdAfterDate = date
        }

        if let createdBefore = currentCreatedBefore,
           let date = dateFormatter.date(from: createdBefore),
           date >= createdAfterDate
        { // Ensure valid range
            createdBeforeDate = date
        }
    }

    func resetFilters() {
        query = ""
        category = ""
        createdAfterDate = filters.minDate
        createdBeforeDate = filters.maxDate
    }

    func applyFilters() {
        let calendar = Calendar.current

        // Validate date range - ensure after date isn't later than before date
        if calendar.compare(createdAfterDate, to: createdBeforeDate, toGranularity: .day) == .orderedDescending {
            // If range is inverted, reset to filter bounds
            createdAfterDate = filters.minDate
            createdBeforeDate = filters.maxDate
        }

        // For the before (max) date:
        // - If it's the max filter day, use exact timestamp
        // - Otherwise use end of day
        let beforeDate: String
        if calendar.isDate(createdBeforeDate, inSameDayAs: filters.maxDate) {
            beforeDate = dateFormatter.string(from: filters.maxDate)
        } else {
            // Get end of the selected day
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: createdBeforeDate)!
            beforeDate = dateFormatter.string(from: endOfDay)
        }

        // For the after (min) date:
        // - If it's the min filter day, use exact timestamp
        // - Otherwise use start of day
        let afterDate: String
        if calendar.isDate(createdAfterDate, inSameDayAs: filters.minDate) {
            afterDate = dateFormatter.string(from: filters.minDate)
        } else {
            // Get start of the selected day
            let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: createdAfterDate)!
            afterDate = dateFormatter.string(from: startOfDay)
        }

        onApplyFilters(
            query.isEmpty ? nil : query,
            category.isEmpty ? nil : category,
            beforeDate,
            afterDate
        )
    }
}
