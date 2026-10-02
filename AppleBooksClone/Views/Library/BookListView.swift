import SwiftUI

public struct BookListView: View {
    public let books: [Book]
    public var onSelect: (Book) -> Void
    public var onRead: (Book) -> Void
    public var onToggleWantToRead: (Book) -> Void
    public var onToggleFinished: (Book) -> Void

    public var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(books) { book in
                BookRowView(
                    book: book,
                    onSelect: { onSelect(book) },
                    onRead: { onRead(book) },
                    onToggleWantToRead: { onToggleWantToRead(book) },
                    onToggleFinished: { onToggleFinished(book) }
                )

                if book.id != books.last?.id {
                    Divider()
                        .padding(.leading, 76)
                }
            }
        }
    }
}
