import SwiftUI

public struct CircularProgressView: View {
    public var progress: Double
    public var lineWidth: CGFloat
    public var primaryColor: Color
    public var secondaryColor: Color

    public init(
        progress: Double,
        lineWidth: CGFloat = 8,
        primaryColor: Color = Color.orange,
        secondaryColor: Color = Color.orange.opacity(0.2)
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }

    public var body: some View {
        ZStack {
            // 背景圆环
            Circle()
                .stroke(secondaryColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // 进度圆环
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [primaryColor, Color.pink, primaryColor]),
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progress)
        }
    }
}
