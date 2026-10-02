import Foundation

public struct Chapter: Identifiable, Codable, Hashable {
    public let id: UUID
    public var title: String
    public var content: String
    public var startPage: Int
    public var pageCount: Int

    public init(
        id: UUID = UUID(),
        title: String,
        content: String,
        startPage: Int = 1,
        pageCount: Int = 10
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.startPage = startPage
        self.pageCount = pageCount
    }
}
