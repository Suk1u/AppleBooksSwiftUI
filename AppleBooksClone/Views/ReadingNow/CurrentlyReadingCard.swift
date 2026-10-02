import SwiftUI

public struct CurrentlyReadingCard: View {
    public let book: Book
    public var onResume: () -> Void
    public var onDetail: () -> Void

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 16) {
                // 封面
                Button(action: onResume) {
                    BookCoverView(book: book, width: 95, height: 142, cornerRadius: 8)
                }
                .buttonStyle(.liquidSpring)

                // 右侧信息
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(book.title)
                            .font(.system(size: 19, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .lineLimit(2)

                        Text(book.author)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    // 进度条与文字
                    VStack(alignment: .leading, spacing: 4) {
                        ReadingProgressBar(
                            progress: book.progressPercentage,
                            height: 4,
                            foregroundColor: .cyan,
                            backgroundColor: Color.white.opacity(0.12)
                        )

                        HStack {
                            Text("第 \(book.currentPage) 页 · 共 \(book.totalPages) 页")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.white.opacity(0.6))

                            Spacer()

                            Text("\(Int(book.progressPercentage * 100))%")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(.cyan)
                        }
                    }
                    .padding(.top, 4)

                    Spacer(minLength: 0)

                    // 继续阅读液态玻璃胶囊按钮
                    Button(action: onResume) {
                        HStack(spacing: 6) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 12, weight: .semibold))
                            Text("继续阅读")
                                .font(.system(size: 13, weight: .semibold))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .liquidGlassPill(cornerRadius: 18, specularOpacity: 0.45)
                    }
                    .buttonStyle(.liquidSpring)
                }
            }
        }
        .padding(16)
        .liquidGlassCard(cornerRadius: 20, specularOpacity: 0.35)
    }
}
