import SwiftUI

// MARK: - 阅读器悬浮液态玻璃多功能菜单 (WWDC25 Native Liquid Glass Reader Menu)

public struct LiquidGlassReaderMenu: View {
    @Binding public var isPresented: Bool
    public var onOpenTOC: () -> Void
    public var onOpenSearch: () -> Void
    public var onOpenSettings: () -> Void
    public var onShare: () -> Void
    public var onToggleLock: () -> Void
    public var onToggleMode: () -> Void
    public var onToggleBookmark: () -> Void
    public var isBookmarked: Bool

    public var body: some View {
        GlassEffectContainer {
            VStack(spacing: 0) {
                // 目录
                Button(action: {
                    isPresented = false
                    onOpenTOC()
                }) {
                    HStack {
                        Text("目录")
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                        Image(systemName: "list.bullet")
                            .font(.system(size: 17))
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 18)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass)

                Divider()
                    .padding(.horizontal, 14)

                // 在图书中搜索
                Button(action: {
                    isPresented = false
                    onOpenSearch()
                }) {
                    HStack {
                        Text("在图书中搜索")
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 17))
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 18)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass)

                Divider()
                    .padding(.horizontal, 14)

                // 主题与设置 (大小)
                Button(action: {
                    isPresented = false
                    onOpenSettings()
                }) {
                    HStack {
                        Text("主题与设置")
                            .font(.system(size: 16, weight: .regular))
                        Spacer()
                        Text("大小")
                            .font(.system(size: 15, weight: .medium, design: .serif))
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 18)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.glass)

                Divider()
                    .padding(.horizontal, 14)
                    .padding(.bottom, 6)

                // 底部 4 个悬浮液态玻璃方块按钮
                HStack(spacing: 8) {
                    // 分享
                    Button(action: onShare) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.glass)

                    // 锁定屏幕旋转
                    Button(action: onToggleLock) {
                        Image(systemName: "lock.rotation")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.glass)

                    // 翻页模式切换
                    Button(action: onToggleMode) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.glass)

                    // 书签收藏
                    Button(action: onToggleBookmark) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isBookmarked ? .cyan : .primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.glass)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
            }
            .frame(width: 260)
            .glassEffect(
                .regular.interactive(),
                in: RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
        }
    }
}
