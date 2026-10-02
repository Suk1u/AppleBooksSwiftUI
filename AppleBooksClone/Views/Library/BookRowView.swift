import SwiftUI

public struct BookRowView: View {
    public let book: Book
    public var onSelect: () -> Void
    public var onRead: () -> Void
    public var onToggleWantToRead: () -> Void
    public var onToggleFinished: () -> Void

    public var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // 封面
                BookCoverView(book: book, width: 60, height: 90, cornerRadius: 4)

                // 中间信息
                VStack(alignment: .leading, spacing: 6) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(book.title)
                            .font(.system(size: 16, weight: .bold, design: .serif))
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Text(book.author)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    HStack(spacing: 8) {
                        Text(book.category.rawValue)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())

                        if book.isWantToRead {
                            HStack(spacing: 2) {
                                Image(systemName: "bookmark.fill")
                                    .font(.system(size: 10))
                                Text("欲读")
                                    .font(.system(size: 11, weight: .medium))
                            }
                            .foregroundColor(.orange)
                        }
                    }

                    // 进度
                    if book.isFinished {
                        Text("已读完 ✓")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    } else if book.currentPage > 0 {
                        HStack(spacing: 8) {
                            ReadingProgressBar(
                                progress: book.progressPercentage,
                                height: 4,
                                foregroundColor: .orange
                            )
                            .frame(width: 80)

                            Text("\(Int(book.progressPercentage * 100))%")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.orange)
                        }
                    } else {
                        Text("未开始阅读")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                // 阅读操作按钮
                Button(action: onRead) {
                    Image(systemName: "book.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.orange)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(action: onRead) {
                Label("开始阅读", systemImage: "book")
            }
            Button(action: onSelect) {
                Label("查看详情", systemImage: "info.circle")
            }
            Button(action: onToggleWantToRead) {
                Label(
                    book.isWantToRead ? "从欲读清单移除" : "加入欲读清单",
                    systemImage: book.isWantToRead ? "bookmark.slash" : "bookmark"
                )
            }
            Button(action: onToggleFinished) {
                Label(
                    book.isFinished ? "标记为未读完" : "标记为已读完",
                    systemImage: book.isFinished ? "xmark.circle" : "checkmark.circle"
                )
            }
        }
    }
}
