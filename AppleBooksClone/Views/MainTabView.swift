import SwiftUI

// MARK: - 主导航视图 (WWDC25 Native Liquid Glass Main Tab View)

public struct MainTabView: View {
    @StateObject private var viewModel = BooksViewModel()
    @State private var selectedTab: AppTab = .library

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            // 底层动态流体渐变背景（保持内容层不被玻璃化）
            DynamicGradientBackground()

            GlassEffectContainer {
                // 页面主体内容
                Group {
                    switch selectedTab {
                    case .home:
                        ReadingNowView(viewModel: viewModel)
                    case .library:
                        LibraryView(viewModel: viewModel)
                    case .store:
                        storePlaceholderView
                    case .audiobooks:
                        audiobooksPlaceholderView
                    case .search:
                        searchPlaceholderView
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // 悬浮流体液态玻璃导航栏 (对齐视频 frame_01, 04, 06)
                LiquidGlassTabBar(selectedTab: $selectedTab)
            }
        }
        // 书籍详情页 Sheet
        .sheet(item: $viewModel.selectedDetailBook) { book in
            BookDetailView(book: book, viewModel: viewModel)
        }
        // 全屏沉浸式阅读界面 FullScreenCover
        .fullScreenCover(item: $viewModel.activeReadingBook) { book in
            ReaderView(book: book, viewModel: viewModel)
        }
    }

    private var storePlaceholderView: some View {
        VStack(spacing: 20) {
            Spacer()
            LiquidGlassCard(cornerRadius: 24) {
                VStack(spacing: 14) {
                    Image(systemName: "bag.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.primary.opacity(0.8))
                    Text("探索书店")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    Text("精选畅销好书与新书推荐")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
            .padding(.horizontal, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var audiobooksPlaceholderView: some View {
        VStack(spacing: 20) {
            Spacer()
            LiquidGlassCard(cornerRadius: 24) {
                VStack(spacing: 14) {
                    Image(systemName: "headphones")
                        .font(.system(size: 48))
                        .foregroundColor(.primary.opacity(0.8))
                    Text("有声书")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    Text("沉浸式专业声优配音听书体验")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
            .padding(.horizontal, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var searchPlaceholderView: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("搜索图书、作者或书名", text: $viewModel.searchText)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 20)
            .padding(.top, 24)

            Spacer()

            LiquidGlassCard(cornerRadius: 22) {
                VStack(spacing: 12) {
                    Image(systemName: "books.vertical")
                        .font(.system(size: 44))
                        .foregroundColor(.secondary)
                    Text("搜索你的全部图书")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
