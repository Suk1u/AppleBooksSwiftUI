import SwiftUI

public enum ReaderTheme: String, CaseIterable, Identifiable {
    case white = "纯白"
    case sepia = "羊皮纸"
    case paper = "水墨灰"
    case dark = "暗夜黑"

    public var id: String { rawValue }

    public var backgroundColor: Color {
        switch self {
        case .white: return Color(white: 0.99)
        case .sepia: return Color(hex: "#F8F1E3")
        case .paper: return Color(hex: "#EAEAEB")
        case .dark: return Color(hex: "#121212")
        }
    }

    public var textColor: Color {
        switch self {
        case .white: return Color(white: 0.1)
        case .sepia: return Color(hex: "#3D2B1F")
        case .paper: return Color(hex: "#1C1C1E")
        case .dark: return Color(hex: "#E5E5EA")
        }
    }

    public var secondaryTextColor: Color {
        switch self {
        case .white: return Color(white: 0.45)
        case .sepia: return Color(hex: "#7A6855")
        case .paper: return Color(hex: "#636366")
        case .dark: return Color(hex: "#8E8E93")
        }
    }

    public var chromeBackground: Color {
        switch self {
        case .white: return Color.white.opacity(0.95)
        case .sepia: return Color(hex: "#EFE6D5").opacity(0.95)
        case .paper: return Color(hex: "#DCDCE0").opacity(0.95)
        case .dark: return Color(hex: "#1C1C1E").opacity(0.95)
        }
    }
}
