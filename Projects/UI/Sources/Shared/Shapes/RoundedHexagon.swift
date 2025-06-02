import Core
import CoreGraphics
import SwiftUI

struct RoundedHexagon: Shape {
    var cornerSize: Size = .md

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width / 2.0, rect.height / sqrt(3.0))

        let points: [CGPoint] = (0 ..< 6).map { i in
            let angle = CGFloat.pi / 3.0 * CGFloat(i) + CGFloat.pi / 6.0
            return CGPoint(
                x: center.x + r * cos(angle),
                y: center.y + r * sin(angle)
            )
        }

        let maxCornerRadius = r / (2.0 * sqrt(3.0))
        let clampedRadius = min(cornerSize.rawValue, maxCornerRadius)

        if clampedRadius <= 0.01 {
            return Path { path in
                path.move(to: points.last!)
                path.addLines(points)
                path.closeSubpath()
            }
        }

        var path = Path()

        let p0 = points[0]
        let pLast = points[5]
        let startTangent = pointOnLine(from: p0, towards: pLast, distance: clampedRadius / tan(.pi / 6.0))
        path.move(to: startTangent)

        for i in 0 ..< points.count {
            let currentPoint = points[i]
            let nextPoint = points[(i + 1) % points.count]
            let prevPoint = points[(i + points.count - 1) % points.count]

            let tangent1 = pointOnLine(from: currentPoint, towards: prevPoint, distance: clampedRadius / tan(.pi / 6.0))
            let tangent2 = pointOnLine(from: currentPoint, towards: nextPoint, distance: clampedRadius / tan(.pi / 6.0))

            path.addLine(to: tangent1)
            path.addArc(tangent1End: currentPoint, tangent2End: tangent2, radius: clampedRadius)
        }

        path.closeSubpath()
        return path
    }

    private func pointOnLine(from: CGPoint, towards: CGPoint, distance: CGFloat) -> CGPoint {
        let vector = CGPoint(x: towards.x - from.x, y: towards.y - from.y)
        let length = sqrt(vector.x * vector.x + vector.y * vector.y)
        guard length > 0 else { return from }
        let normalizedVector = CGPoint(x: vector.x / length, y: vector.y / length)
        return CGPoint(
            x: from.x + normalizedVector.x * distance,
            y: from.y + normalizedVector.y * distance
        )
    }
}
