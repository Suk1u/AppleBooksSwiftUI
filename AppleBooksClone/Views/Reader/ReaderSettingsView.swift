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
            HStack(spacing: 12) {
                Image(systemName: "sun.min")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)

                Slider(value: $brightness, in: 0.2...1.0)
                    .tint(.orange)

                Image(systemName: "sun.max")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)

            Divider()

            // 字号调节 A- / A+
            HStack {
                Text("字号")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)

                Spacer()

                HStack(spacing: 16) {
                    Button(action: {
                        if fontSize > 14 { fontSize -= 2 }
                    }) {
                        Image(systemName: "textformat.size.smaller")
                            .font(.system(size: 15, weight: .bold))
                            .frame(width: 38, height: 32)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .disabled(fontSize <= 14)

                    Text("\(Int(fontSize))")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .frame(width: 28)

                    Button(action: {
                        if fontSize < 28 { fontSize += 2 }
                    }) {
                        Image(systemName: "textformat.size.larger")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 38, height: 32)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .disabled(fontSize >= 28)
                }
            }

            Divider()

            // 字体样式切换
            HStack {
                Text("字体风格")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)

                Spacer()

                Picker("字体风格", selection: $fontDesign) {
                    Text("宋体/衬线").tag(Font.Design.serif)
                    Text("系统/黑体").tag(Font.Design.default)
                    Text("圆体").tag(Font.Design.rounded)
                }
                .pickerStyle(.segmented)
                .frame(width: 210)
            }

            Divider()

            // 主题色板
            HStack(spacing: 14) {
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
                                        .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                                )

                            Text("Aa")
                                .font(.system(size: 14, weight: .bold, design: .serif))
                                .foregroundColor(theme.textColor)

                            if selectedTheme == theme {
                                Circle()
                                    .stroke(Color.orange, lineWidth: 2.5)
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Divider()

            // 翻页模式 / 滚动模式
            HStack {
                Text("页面交互")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)

                Spacer()

                Picker("交互模式", selection: $isScrollMode) {
                    Text("翻页模式").tag(false)
                    Text("上下滚动").tag(true)
                }
                .pickerStyle(.segmented)
                .frame(width: 180)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
