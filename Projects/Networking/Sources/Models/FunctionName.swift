import Foundation

public enum FunctionName: Sendable {
    case ideasFilters
    case ideasList(_ requestData: IdeasListRequest)
    case unlockIdea(_ request: UnlockIdeaRequest)
}
