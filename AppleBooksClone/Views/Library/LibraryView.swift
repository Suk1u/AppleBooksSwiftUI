import SwiftUI

public struct LibraryView: View {
    @ObservedObject public var viewModel: BooksViewModel

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 分类胶囊标签栏
                CategoryPillsView(selectedCategory: $viewModel.selectedCategory)
                    .padding(.top, 8)
                    .padding(.bottom, 6)

                // 排序与视图切换控制条
                HStack {
                    Text("共 \(viewModel.filteredLibraryBooks.count) 本书")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)

                    Spacer()

                    // 排序菜单
                    Menu {
                        ForEach(SortOption.allCases) { option in
                            Button(action: {
                                withAnimation { viewModel.selectedSort = option }
                            }) {
                                HStack {
                                    Text(option.rawValue)
                                    if viewModel.selectedSort == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 12))
                            Text(viewModel.selectedSort.rawValue)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                    }

                    // 网格/列表切换按钮
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.viewMode = (viewModel.viewMode == .grid) ? .list : .grid
                        }
                    }) {
                        Image(systemName: viewModel.viewMode == .grid ? "list.bullet" : "square.grid.2x2")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)

                Divider()

                // 主内容区
                ScrollView(.vertical, showsIndicators: true) {
                    if viewModel.filteredLibraryBooks.isEmpty {
                        VStack(spacing: 16) {
                            Spacer().frame(height: 60)
                            Image(systemName: "books.vertical")
                                .font(.system(size: 52))
                                .foregroundColor(.secondary.opacity(0.6))
                            Text("未找到匹配的书籍")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.secondary)
                            Text("请尝试更换筛选分类或搜索其他关键词")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary.opacity(0.8))
                        }
                        .padding(.top, 40)
                    } else {
                        Group {
                            if viewModel.viewMode == .grid {
                                BookGridView(
                                    books: viewModel.filteredLibraryBooks,
                                    onSelect: { book in
                                        viewModel.selectedDetailBook = book
                                    },
                                    onRead: { book in
                                        viewModel.activeReadingBook = book
                                    },
                                    onToggleWantToRead: { book in
                                        viewModel.toggleWantToRead(for: book.id)
                                    },
                                    onToggleFinished: { book in
                                        viewModel.toggleFinished(for: book.id)
                                    }
                                )
                            } else {
                                BookListView(
                                    books: viewModel.filteredLibraryBooks,
                                    onSelect: { book in
                                        viewModel.selectedDetailBook = book
                                    },
                                    onRead: { book in
                                        viewModel.activeReadingBook = book
                                    },
                                    onToggleWantToRead: { book in
                                        viewModel.toggleWantToRead(for: book.id)
                                    },
                                    onToggleFinished: { book in
                                        viewModel.toggleFinished(for: book.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("书库")
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "在书库中搜索书名、作者或简介"
            )
        }
    }
}
