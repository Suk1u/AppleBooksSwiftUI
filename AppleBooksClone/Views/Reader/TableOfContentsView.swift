import SwiftUI

public struct TableOfContentsView: View {
    public let chapters: [Chapter]
    public let currentChapterIndex: Int
    public var onSelectChapter: (Int) -> Void
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("全书目录 · 共 \(chapters.count) 章")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                        VStack(spacing: 0) {
                            ForEach(Array(chapters.enumerated()), id: \.offset) { index, chapter in
                                Button(action: {
                                    onSelectChapter(index)
                                    dismiss()
                                }) {
                                    HStack {
                                        Text(chapter.title)
                                            .font(.system(size: 16, weight: index == currentChapterIndex ? .bold : .regular))
                                            .foregroundColor(index == currentChapterIndex ? .cyan : .white)

                                        Spacer()

                                        Text("第 \(chapter.startPage) 页")
                                            .font(.system(size: 14, design: .rounded))
                                            .foregroundColor(.white.opacity(0.5))

                                        if index == currentChapterIndex {
                                            Image(systemName: "bookmark.fill")
                                                .font(.system(size: 13))
                                                .foregroundColor(.cyan)
                                                .padding(.leading, 6)
                                        }
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 18)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)

                                if index < chapters.count - 1 {
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                        .padding(.leading, 18)
                                }
                            }
                        }
                        .liquidGlassCard(cornerRadius: 18, specularOpacity: 0.35)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationTitle("目录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .liquidGlassCircle(size: 32, specularOpacity: 0.45)
                    }
                }
            }
        }
    }
}
