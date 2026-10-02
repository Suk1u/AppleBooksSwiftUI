import SwiftUI

public struct BookDetailView: View {
    public let book: Book
    @ObservedObject public var viewModel: BooksViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isSynopsisExpanded: Bool = false

    public var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        // 封面及光影背景
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
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)

                                if let subtitle = book.subtitle {
                                    Text(subtitle)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                }

                                Text(book.author)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.85))
                            }

                            // 评分与评论数
                            HStack(spacing: 4) {
                                ForEach(0..<5) { index in
                                    Image(systemName: Double(index) < book.rating.rounded() ? "star.fill" : "star")
                                        .font(.system(size: 13))
                                        .foregroundColor(.yellow)
                                }

                                Text(String(format: "%.1f", book.rating))
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.leading, 4)

                                Text("(\(book.ratingCount) 评分)")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }

                        // 主要操作按钮组
                        VStack(spacing: 12) {
                            // 核心操作：开始/继续阅读 (液态玻璃胶囊大按钮)
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
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .liquidGlassPill(cornerRadius: 26, specularOpacity: 0.55, shadowRadius: 12)
                            }
                            .buttonStyle(.liquidSpring)

                            // 次要操作：欲读、标记已读
                            HStack(spacing: 12) {
                                // 欲读清单切换
                                Button(action: {
                                    viewModel.toggleWantToRead(for: book.id)
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: book.isWantToRead ? "bookmark.fill" : "bookmark")
                                            .foregroundColor(book.isWantToRead ? .orange : .white)
                                        Text(book.isWantToRead ? "已在欲读" : "欲读清单")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .liquidGlassCard(cornerRadius: 14, specularOpacity: 0.35)
                                }
                                .buttonStyle(.liquidSpring)

                                // 标记已读切换
                                Button(action: {
                                    viewModel.toggleFinished(for: book.id)
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: book.isFinished ? "checkmark.circle.fill" : "checkmark.circle")
                                            .foregroundColor(book.isFinished ? .cyan : .white)
                                        Text(book.isFinished ? "已读完" : "标为已读")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .liquidGlassCard(cornerRadius: 14, specularOpacity: 0.35)
                                }
                                .buttonStyle(.liquidSpring)
                            }
                        }
                        .padding(.horizontal, 20)

                        // 关键参数信息条 (液态玻璃卡片)
                        HStack {
                            VStack(spacing: 4) {
                                Text("页数")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                                Text("\(book.totalPages)")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)

                            Divider().background(Color.white.opacity(0.15)).frame(height: 24)

                            VStack(spacing: 4) {
                                Text("类别")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                                Text(book.category.rawValue)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)

                            Divider().background(Color.white.opacity(0.15)).frame(height: 24)

                            VStack(spacing: 4) {
                                Text("预估时间")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                                Text("约 \(max(1, book.totalPages / 40)) 小时")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.vertical, 14)
                        .liquidGlassCard(cornerRadius: 16, specularOpacity: 0.35)
                        .padding(.horizontal, 20)

                        // 内容简介
                        VStack(alignment: .leading, spacing: 10) {
                            Text("内容简介")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)

                            Text(book.synopsis)
                                .font(.system(size: 15))
                                .lineSpacing(6)
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(isSynopsisExpanded ? nil : 4)

                            Button(action: {
                                withAnimation(.easeInOut) { isSynopsisExpanded.toggle() }
                            }) {
                                Text(isSynopsisExpanded ? "收起" : "展开全文")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.cyan)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                        .liquidGlassCard(cornerRadius: 18, specularOpacity: 0.3)
                        .padding(.horizontal, 20)

                        // 目录速览
                        if !book.chapters.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("目录")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)

                                VStack(spacing: 0) {
                                    ForEach(Array(book.chapters.enumerated()), id: \.offset) { index, chapter in
                                        HStack {
                                            Text(chapter.title)
                                                .font(.system(size: 15))
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text("第 \(chapter.startPage) 页")
                                                .font(.system(size: 13, design: .rounded))
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        .padding(.vertical, 14)

                                        if index < book.chapters.count - 1 {
                                            Divider().background(Color.white.opacity(0.1))
                                        }
                                    }
                                }
                                .padding(.horizontal, 18)
                                .liquidGlassCard(cornerRadius: 18, specularOpacity: 0.3)
                            }
                            .padding(.horizontal, 20)
                        }

                        Spacer().frame(height: 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .liquidGlassCircle(size: 34, specularOpacity: 0.45)
                    }
                }
            }
        }
    }
}
