import Foundation
import Core
import Networking
import SwiftUICore
import SwiftData
import CloudKit

class IdeaDetailsViewModel: ObservableObject {
    let idea: Idea
    private let bookmarkDataSource: DataSource<Bookmark>?
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var selectedTab: DetailTab = .overview
    @Published private(set) var isBookmarked: Bool = false
    
    init(
        idea: Idea,
        bookmarkDataSource: DataSource<Bookmark>? = .init(
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
        )
    ) {
        self.idea = idea
        self.bookmarkDataSource = bookmarkDataSource
    }
    
    func updateSelectedTab(_ tab: DetailTab) {
        selectedTab = tab
    }
    
    @MainActor
    func updateBookmark() async {
        isLoading = true
        isBookmarked = await (try? bookmarkDataSource?.fetchSingle(idea.id)) != nil
        isLoading = false
    }
    
    @MainActor
    func toggleBookmark() async {
        isLoading = true
        guard let bookmarkDataSource else {
            isLoading = false
            return
        }
        
        if isBookmarked {
            // Remove the bookmark
            if await bookmarkDataSource.delete(idea.id) {
                isBookmarked = false
            }
            isLoading = false
            return
        }
        
        // Add new bookmark
        if await bookmarkDataSource.append(Bookmark(id: idea.id)) {
            isBookmarked = true
        }
        isLoading = false
    }
}

// MARK: - Bookmark SwiftData Object

@Model
class Bookmark {
    var id: UUID?
    var createdAt: Date = Date()
    
    init(id: UUID?) {
        self.id = id
    }
}

// MARK: - Detail Tab Enum

enum DetailTab: String, CaseIterable {
    case overview
    case financial
    case market
    case roadmap
    case techStack
    case ethics
    case validation
    
    var title: String {
        switch self {
        case .overview: return "Overview"
        case .financial: return "Financial"
        case .market: return "Market"
        case .roadmap: return "Roadmap"
        case .techStack: return "Tech Stack"
        case .ethics: return "Ethics & Risks"
        case .validation: return "MVP Validation"
        }
    }
}
