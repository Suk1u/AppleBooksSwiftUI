import SwiftUI

// MARK: - 书籍详情页 (WWDC25 Native Liquid Glass Book Detail View)

public struct BookDetailView: View {
    public let book: Book
    @ObservedObject public var viewModel: BooksViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isSynopsisExpanded: Bool = false

    public var body: some View {
        NavigationStack {
            ZStack {
                // 底层动态流体渐变背景
                DynamicGradientBackground()

                GlassEffectContainer {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            // 封面与头部信息
                            VStack(spacing: 16) {
                                BookCoverView(
                                    book: book,
                                    width: 140,
                                    height: 210,
                                    cornerRadius: 8
                                )
                                .padding(.top, 20)

                                // 标题与副标题
                                VStack(spacing: 6) {
                                    Text(book.title)
                                        .font(.system(size: 24, weight: .bold, design: .serif))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)

                                    if let subtitle = book.subtitle {
                                        Text(subtitle)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }

                                    Text(book.author)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                }

                                // 评分与评价数
                                HStack(spacing: 4) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: Double(index) < book.rating.rounded() ? "star.fill" : "star")
                                            .font(.system(size: 13))
                                            .foregroundColor(.yellow)
                                    }

                                    Text(String(format: "%.1f", book.rating))
                                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                                        .foregroundColor(.primary)
                                        .padding(.leading, 4)

                                    Text("(\(book.ratingCount) 评分)")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                            }

                            // 主要操作按钮组 (液态玻璃胶囊大按钮与方块按钮)
                            VStack(spacing: 12) {
                                // 核心操作：开始/继续阅读
                                Button(action: {
                                    dismiss()
                                    viewModel.activeReadingBook = book
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "book.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text(book.currentPage > 0 ? "继续阅读 (\(Int(book.progressPercentage * 100))%)" : "开始阅读")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
                                }
                                .buttonStyle(.glass)

                                // 次要操作：欲读、标记已读
                                HStack(spacing: 12) {
                                    // 欲读清单切换
                                    Button(action: {
                                        viewModel.toggleWantToRead(for: book.id)
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: book.isWantToRead ? "bookmark.fill" : "bookmark")
                                                .foregroundColor(book.isWantToRead ? .orange : .primary)
                                            Text(book.isWantToRead ? "已在欲读" : "欲读清单")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.primary)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    }
                                    .buttonStyle(.glass)

                                    // 标记已读切换
                                    Button(action: {
                                        viewModel.toggleFinished(for: book.id)
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: book.isFinished ? "checkmark.circle.fill" : "checkmark.circle")
                                                .foregroundColor(book.isFinished ? .cyan : .primary)
                                            Text(book.isFinished ? "已读完" : "标为已读")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.primary)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    }
                                    .buttonStyle(.glass)
                                }
                            }
                            .padding(.horizontal, 20)

                            // 关键参数信息条 (液态玻璃卡片)
                            LiquidGlassCard(cornerRadius: 18) {
                                HStack {
                                    VStack(spacing: 4) {
                                        Text("页数")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(.secondary)
                                        Text("\(book.totalPages)")
                                            .font(.system(size: 15, weight: .bold, design: .rounded))
                                            .foregroundColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)

                                    Divider().frame(height: 24)

                                    VStack(spacing: 4) {
                                        Text("类别")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(.secondary)
                                        Text(book.category.rawValue)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity)

                                    Divider().frame(height: 24)

                                    VStack(spacing: 4) {
                                        Text("预估时间")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(.secondary)
                                        Text("约 \(max(1, book.totalPages / 40)) 小时")
                                            .font(.system(size: 14, weight: .bold, design: .rounded))
                                            .foregroundColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal, 20)

                            // 内容简介
                            LiquidGlassCard(cornerRadius: 20) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("内容简介")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.primary)

                                    Text(book.synopsis)
                                        .font(.system(size: 15))
                                        .lineSpacing(6)
                                        .foregroundColor(.secondary)
                                        .lineLimit(isSynopsisExpanded ? nil : 4)

                                    Button(action: {
                                        withAnimation(.easeInOut) { isSynopsisExpanded.toggle() }
                                    }) {
                                        Text(isSynopsisExpanded ? "收起" : "展开全文")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.cyan)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)

                            // 目录速览
                            if !book.chapters.isEmpty {
                                LiquidGlassCard(cornerRadius: 20) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("目录")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.primary)

                                        VStack(spacing: 0) {
                                            ForEach(Array(book.chapters.enumerated()), id: \.offset) { index, chapter in
                                                HStack {
                                                    Text(chapter.title)
                                                        .font(.system(size: 15))
                                                        .foregroundColor(.primary)
                                                    Spacer()
                                                    Text("第 \(chapter.startPage) 页")
                                                        .font(.system(size: 13, design: .rounded))
                                                        .foregroundColor(.secondary)
                                                }
                                                .padding(.vertical, 14)

                                                if index < book.chapters.count - 1 {
                                                    Divider()
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }

                            Spacer().frame(height: 30)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.primary)
                            .frame(width: 32, height: 32)
                            .glassEffect(.regular.interactive(), in: Circle())
                    }
                    .buttonStyle(.glass)
                }
            }
        }
    }
}
