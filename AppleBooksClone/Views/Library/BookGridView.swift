import SwiftUI
import UIKit

public struct BookGridView: View {
    public let books: [Book]
    public var onSelect: (Book) -> Void
    public var onRead: (Book) -> Void
    public var onToggleWantToRead: (Book) -> Void
    public var onToggleFinished: (Book) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 20, alignment: .top),
        GridItem(.flexible(), spacing: 20, alignment: .top)
    ]

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 24) {
            ForEach(books) { book in
                VStack(alignment: .leading, spacing: 8) {
                    // 封面
                    Button(action: { onRead(book) }) {
                        BookCoverView(
                            book: book,
                            width: (UIScreen.main.bounds.width - 60) / 2,
                            height: ((UIScreen.main.bounds.width - 60) / 2) * 1.48,
                            showProgressOverlay: false,
                            cornerRadius: 6
                        )
                    }
                    .buttonStyle(.liquidSpring)

                    // 封面底部信息条（对应视频 frame_06：进度% / 新增圆角徽标 + 云朵图标 + ... 更多按钮）
                    HStack(alignment: .center, spacing: 6) {
                        if book.currentPage == 0 {
                            Text("新增")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2.5)
                                .background(Color.blue)
                                .clipShape(Capsule())
                        } else {
                            Text("\(max(1, Int(book.progressPercentage * 100)))%")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.white.opacity(0.65))
                        }

                        Spacer()

                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))

                        Menu {
                            Button(action: { onRead(book) }) {
                                Label("阅读", systemImage: "book")
                            }
                            Button(action: { onToggleWantToRead(book) }) {
                                Label(book.isWantToRead ? "从欲读清单移除" : "加入欲读清单", systemImage: "bookmark")
                            }
                            Button(action: { onToggleFinished(book) }) {
                                Label(book.isFinished ? "标记为未读完" : "标记为已读完", systemImage: "checkmark.circle")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }
}
