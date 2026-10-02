import SwiftUI

// MARK: - 可复用液态玻璃卡片组件 (Reusable Liquid Glass Card)

public struct LiquidGlassCard<Content: View>: View {
    public var cornerRadius: CGFloat
    public var isInteractive: Bool
    @ViewBuilder public let content: () -> Content

    public init(
        cornerRadius: CGFloat = 24,
        isInteractive: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.isInteractive = isInteractive
        self.content = content
    }

    public var body: some View {
        content()
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(
                isInteractive ? .regular.interactive() : .regular,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
    }
}
