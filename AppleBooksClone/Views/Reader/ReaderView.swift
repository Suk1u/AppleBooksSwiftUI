import SwiftUI

public struct ReaderView: View {
    public let book: Book
    @ObservedObject public var viewModel: BooksViewModel
    @Environment(\.dismiss) private var dismiss

    // 阅读状态
    @State private var currentPage: Int
    @State private var currentChapterIndex: Int = 0
    @State private var isChromeVisible: Bool = true
    @State private var isBookmarked: Bool = false
    @State private var showReaderMenu: Bool = false
    @State private var isOrientationLocked: Bool = false

    // 排版与主题设置
    @State private var fontSize: CGFloat = 17
    @State private var fontDesign: Font.Design = .serif
    @State private var selectedTheme: ReaderTheme = .dark
    @State private var isScrollMode: Bool = false
    @State private var brightness: Double = 1.0

    // 弹窗
    @State private var showSettingsSheet: Bool = false
    @State private var showTOCSheet: Bool = false
    @State private var showSearchSheet: Bool = false

    public init(book: Book, viewModel: BooksViewModel) {
        self.book = book
        self.viewModel = viewModel
        _currentPage = State(initialValue: max(book.currentPage, 1))
    }

    private var currentChapter: Chapter {
        if book.chapters.indices.contains(currentChapterIndex) {
            return book.chapters[currentChapterIndex]
        }
        return Chapter(
            title: "正文",
            content: "暂无更多章节内容。",
            startPage: 1,
            pageCount: book.totalPages
        )
    }

    private var remainingPagesInChapter: Int {
        let ch = currentChapter
        let endPage = ch.startPage + ch.pageCount - 1
        return max(endPage - currentPage, 0)
    }

    public var body: some View {
        ZStack {
            // 背景阅读主题底色
            selectedTheme.backgroundColor
                .ignoresSafeArea()

            // 亮度微调遮罩
            if brightness < 1.0 {
                Color.black.opacity(1.0 - brightness)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            // 正文区域
            GeometryReader { proxy in
                ZStack {
                    VStack(alignment: .leading, spacing: 18) {
                        Text(currentChapter.title)
                            .font(.system(size: fontSize + 6, weight: .bold, design: fontDesign))
                            .foregroundColor(selectedTheme.textColor)
                            .padding(.top, isChromeVisible ? 64 : 20)
                            .padding(.bottom, 4)

                        Text(currentChapter.content)
                            .font(.system(size: fontSize, weight: .regular, design: fontDesign))
                            .foregroundColor(selectedTheme.textColor)
                            .lineSpacing(fontSize * 0.52)
                            .multilineTextAlignment(.leading)

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                    // 左右边缘手势翻页，中间呼出液态玻璃菜单
                    HStack(spacing: 0) {
                        Color.clear
                            .frame(width: proxy.size.width * 0.25)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                previousPage()
                            }

                        Color.clear
                            .frame(width: proxy.size.width * 0.50)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    if showReaderMenu {
                                        showReaderMenu = false
                                    } else {
                                        isChromeVisible.toggle()
                                    }
                                }
                            }

                        Color.clear
                            .frame(width: proxy.size.width * 0.25)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                nextPage()
                            }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 30)
                        .onEnded { value in
                            if value.translation.width < -30 {
                                nextPage()
                            } else if value.translation.width > 30 {
                                previousPage()
                            }
                        }
                )
            }

            // 右侧边缘垂直液态玻璃进度滑槽 (对应视频 frame_08, 09)
            if isChromeVisible {
                HStack {
                    Spacer()
                    VerticalPageScrubber(currentPage: $currentPage, totalPages: book.totalPages)
                        .padding(.trailing, 10)
                        .transition(.opacity)
                }
            }

            // 顶部悬浮液态玻璃控件 (对应视频 frame_08, 10)
            if isChromeVisible {
                VStack {
                    HStack {
                        Spacer()

                        // 顶部居中：本章剩余页码液态玻璃胶囊徽标
                        Text(remainingPagesInChapter == 0 ? "本章最后一页" : "本章还剩 \(remainingPagesInChapter) 页")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .liquidGlassPill(cornerRadius: 16, specularOpacity: 0.35)

                        Spacer()

                        // 右上角：圆形液态玻璃关闭按钮 (X)
                        Button(action: {
                            viewModel.updateProgress(for: book.id, toPage: currentPage)
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .liquidGlassCircle(size: 38, specularOpacity: 0.5)
                        }
                        .buttonStyle(.liquidSpring)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)

                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // 底部悬浮液态玻璃控件 (对应视频 frame_08, 09, 10)
            if isChromeVisible {
                VStack {
                    Spacer()

                    // 右下角展开的液态玻璃阅读菜单面板
                    if showReaderMenu {
                        HStack {
                            Spacer()
                            LiquidGlassReaderMenu(
                                isPresented: $showReaderMenu,
                                onOpenTOC: { showTOCSheet = true },
                                onOpenSearch: { showSearchSheet = true },
                                onOpenSettings: { showSettingsSheet = true },
                                onShare: {},
                                onToggleLock: { isOrientationLocked.toggle() },
                                onToggleMode: { isScrollMode.toggle() },
                                onToggleBookmark: { isBookmarked.toggle() },
                                isBookmarked: isBookmarked
                            )
                            .padding(.trailing, 20)
                            .padding(.bottom, 60)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.85, anchor: .bottomTrailing).combined(with: .opacity),
                                removal: .scale(scale: 0.85, anchor: .bottomTrailing).combined(with: .opacity)
                            ))
                        }
                    }

                    // 底部常驻栏：页码胶囊 + 右下角悬浮圆形菜单按钮
                    HStack(alignment: .center) {
                        Spacer()

                        // 底部居中：页码进度液态玻璃胶囊 (例: 16/255 页)
                        Text("\(currentPage)/\(book.totalPages) 页")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .liquidGlassPill(cornerRadius: 16, specularOpacity: 0.35)

                        Spacer()

                        // 右下角：圆形液态玻璃菜单触发按钮
                        Button(action: {
                            withAnimation(.spring(response: 0.36, dampingFraction: 0.74)) {
                                showReaderMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .liquidGlassCircle(size: 42, specularOpacity: 0.5)
                        }
                        .buttonStyle(.liquidSpring)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 22)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .statusBarHidden(!isChromeVisible)
        .sheet(isPresented: $showSettingsSheet) {
            ReaderSettingsView(
                fontSize: $fontSize,
                fontDesign: $fontDesign,
                selectedTheme: $selectedTheme,
                isScrollMode: $isScrollMode,
                brightness: $brightness
            )
            .presentationDetents([.height(380)])
        }
        .sheet(isPresented: $showTOCSheet) {
            TableOfContentsView(
                chapters: book.chapters,
                currentChapterIndex: currentChapterIndex,
                onSelectChapter: { index in
                    currentChapterIndex = index
                    if book.chapters.indices.contains(index) {
                        currentPage = book.chapters[index].startPage
                    }
                }
            )
        }
        .onAppear {
            updateChapterFromPage(currentPage)
        }
        .onDisappear {
            viewModel.updateProgress(for: book.id, toPage: currentPage)
        }
    }

    private func nextPage() {
        if currentPage < book.totalPages {
            withAnimation(.easeInOut(duration: 0.18)) {
                currentPage += 1
                updateChapterFromPage(currentPage)
            }
        }
    }

    private func previousPage() {
        if currentPage > 1 {
            withAnimation(.easeInOut(duration: 0.18)) {
                currentPage -= 1
                updateChapterFromPage(currentPage)
            }
        }
    }

    private func updateChapterFromPage(_ page: Int) {
        for (index, ch) in book.chapters.enumerated().reversed() {
            if page >= ch.startPage {
                currentChapterIndex = index
                break
            }
        }
    }
}
