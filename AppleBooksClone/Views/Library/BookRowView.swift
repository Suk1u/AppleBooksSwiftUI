import SwiftUI

public struct BookRowView: View {
    public let book: Book
    public var onSelect: () -> Void
    public var onRead: () -> Void
    public var onToggleWantToRead: () -> Void
    public var onToggleFinished: () -> Void

    public var body: some View {
        Button(action: onRead) {
            HStack(spacing: 16) {
                // 封面
                BookCoverView(book: book, width: 62, height: 92, cornerRadius: 4)

                // 中间标题与信息
                VStack(alignment: .leading, spacing: 5) {
                    Text(book.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)

                    Text(book.author)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)

                    if book.currentPage == 0 {
                        Text("新增")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    } else {
                        Text("\(max(1, Int(book.progressPercentage * 100)))%")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }

                Spacer()

                // 右侧云朵图标与更多菜单
                HStack(spacing: 16) {
                    Image(systemName: "icloud.and.arrow.down")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.6))

                    Menu {
                        Button(action: onRead) {
                            Label("阅读", systemImage: "book")
                        }
                        Button(action: onToggleWantToRead) {
                            Label(book.isWantToRead ? "从欲读清单移除" : "加入欲读清单", systemImage: "bookmark")
                        }
                        Button(action: onToggleFinished) {
                            Label(book.isFinished ? "标记为未读完" : "标记为已读完", systemImage: "checkmark.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 28, height: 28)
                    }
                }
            }
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.liquidSpring)
    }
}
