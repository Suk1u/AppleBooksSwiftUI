import SwiftUI

// MARK: - 液态玻璃视觉修饰符与样式规范 (iOS 26+ Liquid Glass Design)

public struct LiquidGlassCardModifier: ViewModifier {
    public var cornerRadius: CGFloat
    public var tintColor: Color
    public var specularOpacity: Double
    public var shadowRadius: CGFloat

    public init(
        cornerRadius: CGFloat = 24,
        tintColor: Color = Color.white.opacity(0.06),
        specularOpacity: Double = 0.45,
        shadowRadius: CGFloat = 16
    ) {
        self.cornerRadius = cornerRadius
        self.tintColor = tintColor
        self.specularOpacity = specularOpacity
        self.shadowRadius = shadowRadius
    }

    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // 底层极薄模糊玻璃材质
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)

                    // 液态微光色散层
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    tintColor.opacity(0.6),
                                    Color.white.opacity(0.04),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // 玻璃镜面反光倒角棱线 (Specular Highlight Border)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                stops: [
                                    .init(color: Color.white.opacity(specularOpacity), location: 0.0),
                                    .init(color: Color.white.opacity(0.2), location: 0.3),
                                    .init(color: Color.white.opacity(0.05), location: 0.7),
                                    .init(color: Color.white.opacity(specularOpacity * 0.6), location: 1.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.0
                        )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.22), radius: shadowRadius, x: 0, y: shadowRadius * 0.45)
            .shadow(color: Color.black.opacity(0.12), radius: 3, x: 0, y: 1)
    }
}

public extension View {
    /// 应用 iOS 26+ 液态玻璃卡片效果
    func liquidGlassCard(
        cornerRadius: CGFloat = 24,
        tintColor: Color = Color.white.opacity(0.06),
        specularOpacity: Double = 0.45,
        shadowRadius: CGFloat = 16
    ) -> some View {
        modifier(LiquidGlassCardModifier(
            cornerRadius: cornerRadius,
            tintColor: tintColor,
            specularOpacity: specularOpacity,
            shadowRadius: shadowRadius
        ))
    }

    /// 应用液态玻璃悬浮按钮/药丸徽章效果
    func liquidGlassPill(
        cornerRadius: CGFloat = 30,
        specularOpacity: Double = 0.45,
        shadowRadius: CGFloat = 8
    ) -> some View {
        self
            .background(
                ZStack {
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)

                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.08))

                    Capsule(style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(specularOpacity),
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                }
            )
            .clipShape(Capsule(style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: shadowRadius, x: 0, y: shadowRadius * 0.4)
    }

    /// 应用圆形液态玻璃按钮效果
    func liquidGlassCircle(
        size: CGFloat = 42,
        specularOpacity: Double = 0.45
    ) -> some View {
        self
            .frame(width: size, height: size)
            .background(
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)

                    Circle()
                        .fill(Color.white.opacity(0.07))

                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(specularOpacity),
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.35)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                }
            )
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
    }
}

// MARK: - 液态按压微动效按钮样式 (Liquid Spring ButtonStyle)
public struct LiquidSpringButtonStyle: ButtonStyle {
    public var scaleAmount: CGFloat
    public init(scaleAmount: CGFloat = 0.94) {
        self.scaleAmount = scaleAmount
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .animation(.spring(response: 0.32, dampingFraction: 0.65), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == LiquidSpringButtonStyle {
    static var liquidSpring: LiquidSpringButtonStyle {
        LiquidSpringButtonStyle()
    }
}
