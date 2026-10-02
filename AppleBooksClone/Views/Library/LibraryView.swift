import SwiftUI

// MARK: - “书库” 视图 (WWDC25 Liquid Glass 架构)

public struct LibraryView: View {
    @ObservedObject public var viewModel: BooksViewModel
    @State private var showSortMenu: Bool = false
    @State private var isSelectMode: Bool = false

    public var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                // 底层动态流体渐变背景
                DynamicGradientBackground()

                GlassEffectContainer {
                    VStack(spacing: 0) {
                        // 顶部导航栏 (书库大标题 + 右侧两个液态玻璃圆形按钮)
                        HStack(alignment: .center) {
                            Text("书库")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.primary)

                            Spacer()

                            HStack(spacing: 12) {
                                // 排序与视图模式液态玻璃圆形按钮 (对应视频三条横线图标)
                                Button(action: {
                                    withAnimation(.spring(response: 0.36, dampingFraction: 0.74)) {
                                        showSortMenu.toggle()
                                    }
                                }) {
                                    Image(systemName: "line.3.horizontal")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                        .frame(width: 40, height: 40)
                                        .glassEffect(.regular.interactive(), in: Circle())
                                }
                                .buttonStyle(.glass)

                                // 更多选项液态玻璃圆形按钮
                                Button(action: {
                                    withAnimation(.spring(response: 0.36, dampingFraction: 0.74)) {
                                        showSortMenu.toggle()
                                    }
                                }) {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .frame(width: 40, height: 40)
                                        .glassEffect(.regular.interactive(), in: Circle())
                                }
                                .buttonStyle(.glass)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 12)

                        // 主内容展示区 (网格或列表)
                        ScrollView(.vertical, showsIndicators: false) {
                            Group {
                                if viewModel.viewMode == .grid {
                                    BookGridView(
                                        books: viewModel.filteredLibraryBooks,
                                        onSelect: { book in
                                            viewModel.activeReadingBook = book
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
                                            viewModel.activeReadingBook = book
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
                            .padding(.top, 8)
                            .padding(.bottom, 100) // 避让底部悬浮玻璃 TabBar
                        }
                    }

                    // 悬浮液态玻璃弹出菜单卡片
                    if showSortMenu {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring(response: 0.32, dampingFraction: 0.78)) {
                                    showSortMenu = false
                                }
                            }

                        LiquidGlassMenuSheet(
                            isPresented: $showSortMenu,
                            viewMode: $viewModel.viewMode,
                            selectedSort: $viewModel.selectedSort,
                            onSelectMode: {
                                isSelectMode.toggle()
                            },
                            onRemoveDownloads: {}
                        )
                        .padding(.top, 58)
                        .padding(.trailing, 16)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.9, anchor: .topTrailing).combined(with: .opacity),
                            removal: .scale(scale: 0.9, anchor: .topTrailing).combined(with: .opacity)
                        ))
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
