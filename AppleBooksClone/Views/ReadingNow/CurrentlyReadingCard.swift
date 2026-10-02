import SwiftUI

public struct CurrentlyReadingCard: View {
    public let book: Book
    public var onResume: () -> Void
    public var onDetail: () -> Void

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 16) {
                // 封面
                Button(action: onDetail) {
                    BookCoverView(book: book, width: 95, height: 142, cornerRadius: 8)
                }
                .buttonStyle(.plain)

                // 右侧信息
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(book.title)
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundColor(.primary)
                            .lineLimit(2)

                        Text(book.author)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    // 进度条与文字
                    VStack(alignment: .leading, spacing: 4) {
                        ReadingProgressBar(
                            progress: book.progressPercentage,
                            height: 5,
                            foregroundColor: .orange
                        )

                        HStack {
                            Text("第 \(book.currentPage) 页 · 共 \(book.totalPages) 页")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)

                            Spacer()

                            Text("\(Int(book.progressPercentage * 100))%")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.top, 4)

                    Spacer(minLength: 0)

                    // 继续阅读按钮
                    Button(action: onResume) {
                        HStack(spacing: 6) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 13, weight: .semibold))
                            Text("继续阅读")
                                .font(.system(size: 14, weight: .semibold))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [Color.orange, Color.orange.opacity(0.85)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color.orange.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
}
