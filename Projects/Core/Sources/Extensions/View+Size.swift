import SwiftUI

public extension View {
    @inlinable nonisolated func padding(
        _ edges: Edge.Set = .all,
        _ length: Size
    ) -> some View {
        padding(edges, length.rawValue)
    }

    @inlinable nonisolated func frame(
        widthSize: Size,
        heightSize: Size,
        alignment _: Alignment = .center
    ) -> some View {
        frame(width: widthSize.rawValue, height: heightSize.rawValue)
    }
}

public extension VStack {
    @inlinable nonisolated init(
        alignment: HorizontalAlignment = .center,
        spacingSize: Size,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacingSize.rawValue,
            content: content
        )
    }
}

public extension LazyVStack {
    @inlinable nonisolated init(
        alignment: HorizontalAlignment = .center,
        spacingSize: Size,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacingSize.rawValue,
            content: content
        )
    }
}

public extension HStack {
    @inlinable nonisolated init(
        alignment: VerticalAlignment = .center,
        spacingSize: Size,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacingSize.rawValue,
            content: content
        )
    }
}

public extension LazyHStack {
    @inlinable nonisolated init(
        alignment: VerticalAlignment = .center,
        spacingSize: Size,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: spacingSize.rawValue,
            content: content
        )
    }
}
