import SwiftUI

public enum BookCategory: String, CaseIterable, Codable, Identifiable {
    case all = "全部"
    case reading = "正在阅读"
    case wantToRead = "欲读清单"
    case finished = "已读完"
    case fiction = "文学小说"
    case sciFi = "科幻小说"
    case business = "商业与思维"
    case philosophy = "社科哲学"

    public var id: String { rawValue }
}

public enum SortOption: String, CaseIterable, Identifiable {
    case recent = "最近阅读"
    case title = "按书名"
    case author = "按作者"
    case progress = "按阅读进度"

    public var id: String { rawValue }
}

public enum ViewMode: String, CaseIterable, Identifiable {
    case grid = "网格"
    case list = "列表"

    public var id: String { rawValue }
}

public struct BookCoverTheme: Codable, Hashable {
    public var primaryColorHex: String
    public var secondaryColorHex: String
    public var textColorHex: String
    public var spineColorHex: String

    public init(
        primary: String,
        secondary: String,
        text: String = "#FFFFFF",
        spine: String = "#00000040"
    ) {
        self.primaryColorHex = primary
        self.secondaryColorHex = secondary
        self.textColorHex = text
        self.spineColorHex = spine
    }

    public var primaryColor: Color { Color(hex: primaryColorHex) }
    public var secondaryColor: Color { Color(hex: secondaryColorHex) }
    public var textColor: Color { Color(hex: textColorHex) }
    public var spineColor: Color { Color(hex: spineColorHex) }
}

public struct Book: Identifiable, Codable, Hashable {
    public let id: UUID
    public var title: String
    public var subtitle: String?
    public var author: String
    public var category: BookCategory
    public var synopsis: String
    public var rating: Double
    public var ratingCount: Int
    public var totalPages: Int
    public var currentPage: Int
    public var isWantToRead: Bool
    public var isFinished: Bool
    public var lastReadDate: Date?
    public var coverTheme: BookCoverTheme
    public var chapters: [Chapter]

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        author: String,
        category: BookCategory,
        synopsis: String,
        rating: Double,
        ratingCount: Int,
        totalPages: Int,
        currentPage: Int = 0,
        isWantToRead: Bool = false,
        isFinished: Bool = false,
        lastReadDate: Date? = nil,
        coverTheme: BookCoverTheme,
        chapters: [Chapter] = []
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.category = category
        self.synopsis = synopsis
        self.rating = rating
        self.ratingCount = ratingCount
        self.totalPages = totalPages
        self.currentPage = currentPage
        self.isWantToRead = isWantToRead
        self.isFinished = isFinished
        self.lastReadDate = lastReadDate
        self.coverTheme = coverTheme
        self.chapters = chapters
    }

    public var progressPercentage: Double {
        guard totalPages > 0 else { return 0 }
        return min(max(Double(currentPage) / Double(totalPages), 0), 1.0)
    }

    public var progressText: String {
        if isFinished {
            return "已读完"
        } else if currentPage == 0 {
            return "未开始"
        } else {
            let pct = Int(progressPercentage * 100)
            return "已读 \(pct)%"
        }
    }

    public var estimatedRemainingMinutes: Int {
        guard totalPages > currentPage else { return 0 }
        let remainingPages = totalPages - currentPage
        return Int(Double(remainingPages) * 1.5)
    }
}
