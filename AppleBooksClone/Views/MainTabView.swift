import SwiftUI

public struct MainTabView: View {
    @StateObject private var viewModel = BooksViewModel()
    @State private var selectedTab: Int = 0

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            // “阅读中”板块
            ReadingNowView(viewModel: viewModel)
                .tabItem {
                    Label("阅读中", systemImage: "book.fill")
                }
                .tag(0)

            // “书库”板块
            LibraryView(viewModel: viewModel)
                .tabItem {
                    Label("书库", systemImage: "books.vertical.fill")
                }
                .tag(1)
        }
        .tint(.orange)
        // 书籍详情页 Sheet
        .sheet(item: $viewModel.selectedDetailBook) { book in
            BookDetailView(book: book, viewModel: viewModel)
        }
        // 全屏阅读界面 FullScreenCover
        .fullScreenCover(item: $viewModel.activeReadingBook) { book in
            ReaderView(book: book, viewModel: viewModel)
        }
    }
}
