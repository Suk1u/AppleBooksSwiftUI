import SwiftUI

// MARK: - 底层动态渐变背景 (保留底层内容，供悬浮液态玻璃进行真实光学折射)

public struct DynamicGradientBackground: View {
    @State private var animateGradient: Bool = false
    @Environment(\.colorScheme) private var colorScheme

    public init() {}

    public var body: some View {
        ZStack {
            // 底层纯色基底
            (colorScheme == .dark ? Color(white: 0.05) : Color(white: 0.96))
                .ignoresSafeArea()

            // 动态流体色彩光斑 1
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (colorScheme == .dark ? Color.indigo.opacity(0.45) : Color.blue.opacity(0.2)),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 260
                    )
                )
                .frame(width: 480, height: 480)
                .offset(x: animateGradient ? -100 : 120, y: animateGradient ? -160 : 60)
                .blur(radius: 60)

            // 动态流体色彩光斑 2
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (colorScheme == .dark ? Color.purple.opacity(0.35) : Color.pink.opacity(0.2)),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 240
                    )
                )
                .frame(width: 440, height: 440)
                .offset(x: animateGradient ? 140 : -80, y: animateGradient ? 180 : -100)
                .blur(radius: 60)

            // 动态流体色彩光斑 3 (柔和浅色/深色呼吸过渡)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (colorScheme == .dark ? Color.cyan.opacity(0.25) : Color.orange.opacity(0.18)),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 220
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: animateGradient ? -60 : 80, y: animateGradient ? 280 : 320)
                .blur(radius: 65)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}
