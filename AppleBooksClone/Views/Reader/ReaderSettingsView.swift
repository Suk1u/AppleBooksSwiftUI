import SwiftUI

public struct ReaderSettingsView: View {
    @Binding public var fontSize: CGFloat
    @Binding public var fontDesign: Font.Design
    @Binding public var selectedTheme: ReaderTheme
    @Binding public var isScrollMode: Bool
    @Binding public var brightness: Double

    public var body: some View {
        VStack(spacing: 20) {
            // 亮度调节滑块
            HStack(spacing: 14) {
                Image(systemName: "sun.min")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))

                Slider(value: $brightness, in: 0.2...1.0)
                    .tint(.cyan)

                Image(systemName: "sun.max")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(.horizontal, 4)

            Divider().background(Color.white.opacity(0.12))

            // 字号调节 A- / A+
            HStack {
                Text("字号")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                HStack(spacing: 16) {
                    Button(action: {
                        if fontSize > 13 { fontSize -= 2 }
                    }) {
                        Image(systemName: "textformat.size.smaller")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 34)
                            .background(Color.white.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(fontSize <= 13)

                    Text("\(Int(fontSize))")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 28)

                    Button(action: {
                        if fontSize < 28 { fontSize += 2 }
                    }) {
                        Image(systemName: "textformat.size.larger")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 34)
                            .background(Color.white.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(fontSize >= 28)
                }
            }

            Divider().background(Color.white.opacity(0.12))

            // 字体样式切换
            HStack {
                Text("字体风格")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Picker("字体风格", selection: $fontDesign) {
                    Text("宋体/衬线").tag(Font.Design.serif)
                    Text("系统/黑体").tag(Font.Design.default)
                    Text("圆体").tag(Font.Design.rounded)
                }
                .pickerStyle(.segmented)
                .frame(width: 220)
            }

            Divider().background(Color.white.opacity(0.12))

            // 主题色板
            HStack(spacing: 16) {
                ForEach(ReaderTheme.allCases) { theme in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTheme = theme
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(theme.backgroundColor)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )

                            Text("Aa")
                                .font(.system(size: 14, weight: .bold, design: .serif))
                                .foregroundColor(theme.textColor)

                            if selectedTheme == theme {
                                Circle()
                                    .stroke(Color.cyan, lineWidth: 2.5)
                                    .frame(width: 52, height: 52)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider().background(Color.white.opacity(0.12))

            // 翻页模式 / 滚动模式
            HStack {
                Text("页面交互")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)

                Spacer()

                Picker("交互模式", selection: $isScrollMode) {
                    Text("翻页模式").tag(false)
                    Text("上下滚动").tag(true)
                }
                .pickerStyle(.segmented)
                .frame(width: 180)
            }
        }
        .padding(22)
        .background(
            ZStack {
                Color(white: 0.14)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
