import SwiftUI

public struct MainTabView: View {
    @StateObject private var viewModel = BooksViewModel()
    @State private var selectedTab: AppTab = .library

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()

            // 页面内容
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
        .preferredColorScheme(.dark)
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
        VStack(spacing: 16) {
            Image(systemName: "bag.fill")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.6))
            Text("探索书店")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            Text("精选畅销好书与新书推荐")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }

    private var audiobooksPlaceholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: "headphones")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.6))
            Text("有声书")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            Text("沉浸式专业声优配音听书体验")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }

    private var searchPlaceholderView: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.5))
                TextField("搜索图书、作者或书名", text: $viewModel.searchText)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .liquidGlassCard(cornerRadius: 16, specularOpacity: 0.35)
            .padding(.horizontal, 20)
            .padding(.top, 24)

            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "books.vertical")
                    .font(.system(size: 44))
                    .foregroundColor(.white.opacity(0.4))
                Text("搜索你的全部图书")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
