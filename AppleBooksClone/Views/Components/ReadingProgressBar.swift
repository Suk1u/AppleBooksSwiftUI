import SwiftUI

public struct ReadingProgressBar: View {
    public var progress: Double
    public var height: CGFloat
    public var foregroundColor: Color
    public var backgroundColor: Color

    public init(
        progress: Double,
        height: CGFloat = 4,
        foregroundColor: Color = Color.orange,
        backgroundColor: Color = Color(.systemGray5)
    ) {
        self.progress = progress
        self.height = height
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(backgroundColor)
                    .frame(height: height)

                Capsule()
                    .fill(foregroundColor)
                    .frame(width: max(geometry.size.width * CGFloat(min(max(progress, 0.0), 1.0)), 0), height: height)
            }
        }
        .frame(height: height)
    }
}
