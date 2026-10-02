import SwiftUI

public struct HorizontalBookShelf: View {
    public let title: String
    public let subtitle: String?
    public let books: [Book]
    public var onSelectBook: (Book) -> Void

    public init(
        title: String,
        subtitle: String? = nil,
        books: [Book],
        onSelectBook: @escaping (Book) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.books = books
        self.onSelectBook = onSelectBook
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 标题行
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.primary)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                HStack(spacing: 4) {
                    Text("查看全部")
                        .font(.system(size: 13, weight: .medium))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundColor(.orange)
            }
            .padding(.horizontal, 20)

            // 横向滑动书架
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(books) { book in
                        Button(action: { onSelectBook(book) }) {
                            VStack(alignment: .leading, spacing: 8) {
                                BookCoverView(book: book, width: 105, height: 155, cornerRadius: 6)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(book.title)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .lineLimit(1)

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
                                .frame(width: 105, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }
}
