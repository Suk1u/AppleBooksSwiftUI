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

    // 排版与主题设置
    @State private var fontSize: CGFloat = 18
    @State private var fontDesign: Font.Design = .serif
    @State private var selectedTheme: ReaderTheme = .sepia
    @State private var isScrollMode: Bool = false
    @State private var brightness: Double = 1.0

    // 弹窗状态
    @State private var showSettingsSheet: Bool = false
    @State private var showTOCSheet: Bool = false

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

    public var body: some View {
        ZStack {
            // 背景底色
            selectedTheme.backgroundColor
                .ignoresSafeArea()

            // 亮度调节遮罩
            if brightness < 1.0 {
                Color.black.opacity(1.0 - brightness)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            // 正文阅读区域
            VStack(spacing: 0) {
                // 顶部状态留白（与隐藏控制条联动）
                Spacer().frame(height: isChromeVisible ? 60 : 30)

                // 正文内容
                if isScrollMode {
                    scrollContent
                } else {
                    paginatedContent
                }

                // 底部状态留白
                Spacer().frame(height: isChromeVisible ? 90 : 30)
            }

            // 顶部悬浮控制栏
            VStack {
                if isChromeVisible {
                    topNavigationBar
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
                if isChromeVisible {
                    bottomNavigationBar
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
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
            determineInitialChapter()
        }
        .onDisappear {
            // 退出阅读器时持久化当前进度
            viewModel.updateProgress(for: book.id, toPage: currentPage)
        }
    }

    // 翻页模式正文
    private var paginatedContent: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(alignment: .leading, spacing: 18) {
                    Text(currentChapter.title)
                        .font(.system(size: fontSize + 6, weight: .bold, design: fontDesign))
                        .foregroundColor(selectedTheme.textColor)
                        .padding(.bottom, 6)

                    Text(currentChapter.content)
                        .font(.system(size: fontSize, weight: .regular, design: fontDesign))
                        .foregroundColor(selectedTheme.textColor)
                        .lineSpacing(fontSize * 0.5)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .contentShape(Rectangle())

                // 左右边缘点击翻页，中间点击呼出控制栏
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
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isChromeVisible.toggle()
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
                DragGesture(minimumDistance: 25)
                    .onEnded { value in
                        if value.translation.width < -30 {
                            nextPage()
                        } else if value.translation.width > 30 {
                            previousPage()
                        }
                    }
            )
        }
    }

    // 上下滚动模式正文
    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                ForEach(book.chapters) { chapter in
                    VStack(alignment: .leading, spacing: 14) {
                        Text(chapter.title)
                            .font(.system(size: fontSize + 6, weight: .bold, design: fontDesign))
                            .foregroundColor(selectedTheme.textColor)
                            .padding(.top, 16)

                        Text(chapter.content)
                            .font(.system(size: fontSize, weight: .regular, design: fontDesign))
                            .foregroundColor(selectedTheme.textColor)
                            .lineSpacing(fontSize * 0.5)

                        Divider()
                            .padding(.vertical, 16)
                    }
                }
            }
            .padding(.horizontal, 24)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isChromeVisible.toggle()
                }
            }
        }
    }

    // 顶部控制导航栏
    private var topNavigationBar: some View {
        HStack(spacing: 16) {
            // 返回/关闭按钮
            Button(action: {
                viewModel.updateProgress(for: book.id, toPage: currentPage)
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(selectedTheme.textColor)
                    .frame(width: 36, height: 36)
                    .background(selectedTheme.chromeBackground)
                    .clipShape(Circle())
            }

            Spacer()

            // 章节标题
            Text(currentChapter.title)
                .font(.system(size: 14, weight: .medium, design: fontDesign))
                .foregroundColor(selectedTheme.secondaryTextColor)
                .lineLimit(1)

            Spacer()

            HStack(spacing: 12) {
                // 目录按钮
                Button(action: { showTOCSheet = true }) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selectedTheme.textColor)
                        .frame(width: 36, height: 36)
                        .background(selectedTheme.chromeBackground)
                        .clipShape(Circle())
                }

                // 排版设置 Aa 按钮
                Button(action: { showSettingsSheet = true }) {
                    Image(systemName: "textformat.size")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(selectedTheme.textColor)
                        .frame(width: 36, height: 36)
                        .background(selectedTheme.chromeBackground)
                        .clipShape(Circle())
                }

                // 书签按钮
                Button(action: {
                    withAnimation { isBookmarked.toggle() }
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(isBookmarked ? .orange : selectedTheme.textColor)
                        .frame(width: 36, height: 36)
                        .background(selectedTheme.chromeBackground)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .background(selectedTheme.chromeBackground)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    // 底部控制导航栏
    private var bottomNavigationBar: some View {
        VStack(spacing: 8) {
            // 滑动进度条
            HStack(spacing: 12) {
                Text("\(currentPage)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(selectedTheme.secondaryTextColor)
                    .frame(width: 30, alignment: .trailing)

                Slider(
                    value: Binding(
                        get: { Double(currentPage) },
                        set: { newPage in
                            currentPage = Int(newPage)
                            updateChapterFromPage(currentPage)
                        }
                    ),
                    in: 1...Double(max(book.totalPages, 1)),
                    step: 1
                )
                .tint(.orange)

                Text("\(book.totalPages)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(selectedTheme.secondaryTextColor)
                    .frame(width: 30, alignment: .leading)
            }
            .padding(.horizontal, 20)

            // 页码与进度说明
            HStack {
                let pct = Int((Double(currentPage) / Double(max(book.totalPages, 1))) * 100)
                Text("已读 \(pct)% · 第 \(currentPage) 页 / 共 \(book.totalPages) 页")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(selectedTheme.secondaryTextColor)

                Spacer()

                Text("本章约剩 6 分钟")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(selectedTheme.secondaryTextColor)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .padding(.top, 10)
        .background(selectedTheme.chromeBackground)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: -3)
    }

    private func nextPage() {
        if currentPage < book.totalPages {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentPage += 1
                updateChapterFromPage(currentPage)
            }
        }
    }

    private func previousPage() {
        if currentPage > 1 {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentPage -= 1
                updateChapterFromPage(currentPage)
            }
        }
    }

    private func determineInitialChapter() {
        updateChapterFromPage(currentPage)
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
