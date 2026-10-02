import SwiftUI

public struct TableOfContentsView: View {
    public let chapters: [Chapter]
    public let currentChapterIndex: Int
    public var onSelectChapter: (Int) -> Void
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        NavigationStack {
            List {
                Section(header: Text("全书目录 · 共 \(chapters.count) 章")) {
                    ForEach(Array(chapters.enumerated()), id: \.offset) { index, chapter in
                        Button(action: {
                            onSelectChapter(index)
                            dismiss()
                        }) {
                            HStack {
                                Text(chapter.title)
                                    .font(.system(size: 16, weight: index == currentChapterIndex ? .bold : .regular))
                                    .foregroundColor(index == currentChapterIndex ? .orange : .primary)

                                Spacer()

                                Text("第 \(chapter.startPage) 页")
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(.secondary)

                                if index == currentChapterIndex {
                                    Image(systemName: "bookmark.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.orange)
                                        .padding(.leading, 4)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            .navigationTitle("目录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.orange)
                }
            }
        }
    }
}
