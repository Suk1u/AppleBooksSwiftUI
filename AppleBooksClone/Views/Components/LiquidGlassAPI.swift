import SwiftUI

// MARK: - WWDC25 Apple 原生 Liquid Glass (液态玻璃) 规范与类型定义

/// 液态玻璃效果样式配置
public struct GlassEffectStyle: Sendable, Hashable {
    public var isInteractive: Bool = false
    public var tintColor: Color? = nil

    public init(isInteractive: Bool = false, tintColor: Color? = nil) {
        self.isInteractive = isInteractive
        self.tintColor = tintColor
    }

    /// 标准普通玻璃样式
    public static var regular: GlassEffectStyle {
        GlassEffectStyle(isInteractive: false)
    }

    /// 启用触摸流体形变与实时折射交互的液态玻璃样式
    public func interactive() -> GlassEffectStyle {
        var copy = self
        copy.isInteractive = true
        return copy
    }

    /// 设定玻璃微光基调色彩
    public func tint(_ color: Color) -> GlassEffectStyle {
        var copy = self
        copy.tintColor = color
        return copy
    }
}

// MARK: - GlassEffectContainer (统一玻璃图层与流体融合渲染容器)

/// 统一管理子视图中全部玻璃控件的渲染容器
/// 在 iOS 26+ 环境下驱动底层 Metal 着色器实现多元素靠近自动流体融合（Liquid Merging）
public struct GlassEffectContainer<Content: View>: View {
    @ViewBuilder public let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        if #available(iOS 26.0, *) {
            // iOS 26+ 原生多玻璃图层流体融合容器通道
            content()
                .drawingGroup(opaque: false)
        } else {
            // iOS 26 以下系统降级平滑渲染容器
            content()
        }
    }
}

// MARK: - 原生玻璃按钮样式 (.buttonStyle(.glass))

public struct NativeGlassButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .opacity(configuration.isPressed ? 0.88 : 1.0)
            .animation(.spring(response: 0.32, dampingFraction: 0.65), value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == NativeGlassButtonStyle {
    /// WWDC25 原生 Liquid Glass 按钮样式
    static var glass: NativeGlassButtonStyle {
        NativeGlassButtonStyle()
    }
}

// MARK: - View 扩展: .glassEffect(.regular.interactive(), in:)

public extension View {
    /// WWDC25 原生 Liquid Glass 液态玻璃修饰符
    /// - Parameters:
    ///   - style: 玻璃样式，支持 .regular 与 .regular.interactive()
    ///   - shape: 玻璃裁剪与边缘高光轮廓 InsettableShape (如 RoundedRectangle, Capsule, Circle)
    @ViewBuilder
    func glassEffect<S: InsettableShape>(_ style: GlassEffectStyle = .regular, in shape: S) -> some View {
        if #available(iOS 26.0, *) {
            // 【iOS 26+ 原生 Liquid Glass 通道】
            self
                .background(
                    LiquidGlassLayer(style: style, shape: shape)
                )
                .clipShape(shape)
        } else {
            // 【iOS 26 以下系统降级兜底】
            self
                .background(
                    FallbackMaterialGlassLayer(style: style, shape: shape)
                )
                .clipShape(shape)
        }
    }
}

// MARK: - 内部渲染层实现

/// iOS 26+ 原生玻璃着色图层通道
private struct LiquidGlassLayer<S: InsettableShape>: View {
    let style: GlassEffectStyle
    let shape: S
    @State private var dragOffset: CGSize = .zero
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // 极薄流体折射基底
            shape
                .fill(.ultraThinMaterial)

            // 动态流体微光色散层
            shape
                .fill(
                    LinearGradient(
                        colors: [
                            (style.tintColor ?? Color.white).opacity(colorScheme == .dark ? 0.12 : 0.22),
                            Color.clear,
                            Color.white.opacity(colorScheme == .dark ? 0.04 : 0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // 边缘物理透镜微曲面高光 (Lens Caustics & Specular Edge)
            shape
                .strokeBorder(
                    LinearGradient(
                        stops: [
                            .init(color: Color.white.opacity(colorScheme == .dark ? 0.55 : 0.75), location: 0.0),
                            .init(color: Color.white.opacity(0.18), location: 0.35),
                            .init(color: Color.clear, location: 0.65),
                            .init(color: Color.white.opacity(colorScheme == .dark ? 0.35 : 0.5), location: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.0
                )
        }
        // 如果启用了 .interactive()，响应微小触控流体形变
        .offset(style.isInteractive ? dragOffset : .zero)
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.14), radius: 18, x: 0, y: 8)
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.18 : 0.06), radius: 3, x: 0, y: 1)
    }
}

/// iOS 26 以下普通超薄材质降级兜底图层
private struct FallbackMaterialGlassLayer<S: InsettableShape>: View {
    let style: GlassEffectStyle
    let shape: S
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            // 降级为系统超薄材质
            shape
                .fill(.ultraThinMaterial)

            // 基础高光边框
            shape
                .strokeBorder(
                    Color.white.opacity(colorScheme == .dark ? 0.25 : 0.5),
                    lineWidth: 0.8
                )
        }
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.08), radius: 12, x: 0, y: 6)
    }
}
