import SwiftUI

public struct BookGridView: View {
    public let books: [Book]
    public var onSelect: (Book) -> Void
    public var onRead: (Book) -> Void
    public var onToggleWantToRead: (Book) -> Void
    public var onToggleFinished: (Book) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 105, maximum: 140), spacing: 20, alignment: .top)
    ]

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(books) { book in
                VStack(alignment: .leading, spacing: 8) {
                    // 封面及点击交互
                    Button(action: { onSelect(book) }) {
                        BookCoverView(
                            book: book,
                            width: 105,
                            height: 155,
                            showProgressOverlay: false,
                            cornerRadius: 6
                        )
                    }
                    .buttonStyle(.plain)

                    // 进度条（正在阅读中的书）
                    if book.currentPage > 0 && !book.isFinished {
                        ReadingProgressBar(
                            progress: book.progressPercentage,
                            height: 3,
                            foregroundColor: .orange
                        )
                        .padding(.top, 2)
                    }

                    // 书名与作者
                    VStack(alignment: .leading, spacing: 2) {
                        Text(book.title)
                            .font(.system(size: 14, weight: .bold, design: .serif))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)

                        Text(book.author)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineLimit(1)

                        if book.isFinished {
                            Text("已读完 ✓")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.green)
                        } else if book.currentPage > 0 {
                            Text("\(Int(book.progressPercentage * 100))%")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(.orange)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contextMenu {
                    Button(action: { onRead(book) }) {
                        Label("开始阅读", systemImage: "book")
                    }
                    Button(action: { onSelect(book) }) {
                        Label("书籍详情", systemImage: "info.circle")
                    }
                    Button(action: { onToggleWantToRead(book) }) {
                        Label(
                            book.isWantToRead ? "移出欲读清单" : "加入欲读清单",
                            systemImage: book.isWantToRead ? "bookmark.slash" : "bookmark"
                        )
                    }
                    Button(action: { onToggleFinished(book) }) {
                        Label(
                            book.isFinished ? "标记为未读" : "标记为已读完",
                            systemImage: book.isFinished ? "xmark.circle" : "checkmark.circle"
                        )
                    }
                }
            }
        }
    }
}
