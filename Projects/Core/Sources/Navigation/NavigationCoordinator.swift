import SwiftUI

@MainActor
public protocol NavigationCoordinatorProtocol<Route>: ObservableObject {
    associatedtype Route: Sendable, Hashable

    var path: NavigationPath { get }
    var currentRoute: Route? { get }

    func navigate(to route: Route)
    func pop()
    func reset()
}

public class NavigationCoordinator<Route: Sendable & Hashable>: NavigationCoordinatorProtocol {
    @Published public var path: NavigationPath
    @Published public var currentRoute: Route?
    private var routes: [Route] {
        didSet {
            currentRoute = routes.last
        }
    }

    public init(route: Route? = nil) {
        currentRoute = route
        routes = route != nil ? [route!] : []
        _path = Published(
            initialValue: NavigationPath(routes)
        )
    }

    public func navigate(to route: Route) {
        path.append(route)
        routes.append(route)
    }

    public func pop() {
        guard !path.isEmpty else {
            return
        }
        path.removeLast()
        routes.removeLast()
    }

    public func reset() {
        path = NavigationPath()
        routes = []
    }
}
