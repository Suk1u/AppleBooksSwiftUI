import SwiftUI

public struct BookCoverView: View {
    public let book: Book
    public var width: CGFloat
    public var height: CGFloat?
    public var showProgressOverlay: Bool
    public var cornerRadius: CGFloat

    public init(
        book: Book,
        width: CGFloat = 110,
        height: CGFloat? = nil,
        showProgressOverlay: Bool = false,
        cornerRadius: CGFloat = 6
    ) {
        self.book = book
        self.width = width
        self.height = height ?? (width * 1.5)
        self.showProgressOverlay = showProgressOverlay
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        let actualHeight = height ?? (width * 1.5)

        ZStack(alignment: .bottomLeading) {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [
                    book.coverTheme.primaryColor,
                    book.coverTheme.secondaryColor
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // 书脊模拟光影阴影
            HStack(spacing: 0) {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.35),
                        Color.white.opacity(0.12),
                        Color.clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: max(width * 0.08, 6))

                Spacer()
            }

            // 装饰纹理条纹
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: actualHeight * 0.15)
                Spacer()
                    .frame(height: actualHeight * 0.25)
            }

            // 封面文字内容
            VStack(alignment: .leading, spacing: 4) {
                // 类别徽章
                Text(book.category.rawValue.uppercased())
                    .font(.system(size: max(width * 0.07, 8), weight: .semibold, design: .rounded))
                    .foregroundColor(book.coverTheme.textColor.opacity(0.75))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.2))
                    .clipShape(Capsule())

                Spacer()

                // 书名
                Text(book.title)
                    .font(.system(size: max(width * 0.12, 12), weight: .bold, design: .serif))
                    .foregroundColor(book.coverTheme.textColor)
                    .lineLimit(3)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)

                // 作者
                Text(book.author)
                    .font(.system(size: max(width * 0.08, 9), weight: .medium))
                    .foregroundColor(book.coverTheme.textColor.opacity(0.85))
                    .lineLimit(1)
            }
            .padding(.leading, max(width * 0.12, 10))
            .padding(.trailing, 8)
            .padding(.vertical, 10)

            // 底部进度条指示器（可选覆盖）
            if showProgressOverlay && book.currentPage > 0 {
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.black.opacity(0.4))
                            .frame(height: 4)

                        Rectangle()
                            .fill(Color.white)
                            .frame(width: width * CGFloat(book.progressPercentage), height: 4)
                    }
                }
            }
        }
        .frame(width: width, height: actualHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.18), radius: 6, x: 0, y: 4)
    }
}
