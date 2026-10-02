import SwiftUI

public enum AppTab: Int, CaseIterable, Identifiable {
    case home = 0       // 主页
    case library = 1    // 书库
    case store = 2      // 书店
    case audiobooks = 3 // 有声书
    case search = 4     // 搜索

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .home: return "主页"
        case .library: return "书库"
        case .store: return "书店"
        case .audiobooks: return "有声书"
        case .search: return "搜索"
        }
    }

    public var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .library: return "books.vertical.fill"
        case .store: return "bag.fill"
        case .audiobooks: return "headphones"
        case .search: return "magnifyingglass"
        }
    }
}

public struct LiquidGlassTabBar: View {
    @Binding public var selectedTab: AppTab
    @Namespace private var tabAnimation

    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                let isSelected = selectedTab == tab

                Button(action: {
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.72)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 3) {
                        ZStack {
                            // 流体高光气泡动画背景
                            if isSelected {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.24),
                                                Color.white.opacity(0.08)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .matchedGeometryEffect(id: "liquidActiveTabBubble", in: tabAnimation)
                                    .frame(width: 52, height: 34)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 0.6)
                                    )
                            }

                            Image(systemName: tab.iconName)
                                .font(.system(size: 19, weight: isSelected ? .semibold : .regular))
                                .foregroundColor(isSelected ? .white : .white.opacity(0.55))
                                .frame(height: 24)
                        }
                        .frame(height: 34)

                        Text(tab.title)
                            .font(.system(size: 10, weight: isSelected ? .medium : .regular))
                            .foregroundColor(isSelected ? .white : .white.opacity(0.55))
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(
            ZStack {
                // 底层液态毛玻璃材质
                Capsule(style: .continuous)
                    .fill(.ultraThinMaterial)

                // 半透明微深色流体玻璃叠层
                Capsule(style: .continuous)
                    .fill(Color(white: 0.12).opacity(0.65))

                // 液态高光与反光倒角边框
                Capsule(style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            stops: [
                                .init(color: Color.white.opacity(0.55), location: 0.0),
                                .init(color: Color.white.opacity(0.15), location: 0.3),
                                .init(color: Color.white.opacity(0.05), location: 0.7),
                                .init(color: Color.white.opacity(0.4), location: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.0
                    )
            }
        )
        .clipShape(Capsule(style: .continuous))
        .shadow(color: Color.black.opacity(0.35), radius: 20, x: 0, y: 10)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.bottom, 6)
    }
}
