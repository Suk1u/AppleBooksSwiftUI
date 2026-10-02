import SwiftUI

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
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .frame(height: 48)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Divider()
                .background(Color.white.opacity(0.12))
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
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .frame(height: 48)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Divider()
                .background(Color.white.opacity(0.12))
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
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .frame(height: 48)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Divider()
                .background(Color.white.opacity(0.12))
                .padding(.horizontal, 14)
                .padding(.bottom, 6)

            // 底部 4 个圆角液态玻璃方块按钮
            HStack(spacing: 8) {
                // 分享
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)

                // 锁定方向
                Button(action: onToggleLock) {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)

                // 翻页模式
                Button(action: onToggleMode) {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)

                // 书签
                Button(action: onToggleBookmark) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isBookmarked ? .orange : .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .frame(width: 260)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(white: 0.15).opacity(0.88))
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            stops: [
                                .init(color: Color.white.opacity(0.5), location: 0.0),
                                .init(color: Color.white.opacity(0.15), location: 0.35),
                                .init(color: Color.white.opacity(0.3), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.0
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.45), radius: 24, x: 0, y: 12)
    }
}
