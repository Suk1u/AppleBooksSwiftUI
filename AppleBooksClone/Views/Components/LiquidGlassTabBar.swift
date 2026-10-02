import SwiftUI

// MARK: - App 导航 Tab 枚举定义

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

// MARK: - 悬浮流体液态玻璃导航栏 (WWDC25 Native Liquid Glass Tab Bar)

public struct LiquidGlassTabBar: View {
    @Binding public var selectedTab: AppTab
    @Namespace private var tabNamespace
    @Environment(\.colorScheme) private var colorScheme

    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        GlassEffectContainer {
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
                                // 选中项的液态玻璃融合气泡
                                if isSelected {
                                    Capsule(style: .continuous)
                                        .fill(colorScheme == .dark ? Color.white.opacity(0.18) : Color.black.opacity(0.08))
                                        .frame(width: 52, height: 34)
                                        .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
                                        .matchedGeometryEffect(id: "activeTabLiquidPill", in: tabNamespace)
                                }

                                Image(systemName: tab.iconName)
                                    .font(.system(size: 19, weight: isSelected ? .semibold : .regular))
                                    .foregroundColor(isSelected ? .primary : .secondary)
                                    .frame(height: 24)
                            }
                            .frame(height: 34)

                            Text(tab.title)
                                .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                                .foregroundColor(isSelected ? .primary : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.glass)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
            .padding(.horizontal, 20)
            .padding(.bottom, 6)
        }
    }
}
