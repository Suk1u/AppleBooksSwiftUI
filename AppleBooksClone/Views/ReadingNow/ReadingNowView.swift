import SwiftUI

public struct ReadingNowView: View {
    @ObservedObject public var viewModel: BooksViewModel

    public var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    // 今日阅读目标卡片
                    VStack(alignment: .leading, spacing: 10) {
                        Text("阅读目标")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)

                        ReadingGoalCard(goal: viewModel.readingGoal)
                    }
                    .padding(.horizontal, 20)

                    // 正在阅读专区
                    if !viewModel.currentlyReadingBooks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("正在阅读")
                                .font(.system(size: 22, weight: .bold, design: .serif))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)

                            VStack(spacing: 16) {
                                ForEach(viewModel.currentlyReadingBooks) { book in
                                    CurrentlyReadingCard(
                                        book: book,
                                        onResume: {
                                            viewModel.activeReadingBook = book
                                        },
                                        onDetail: {
                                            viewModel.selectedDetailBook = book
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    // 欲读清单书架
                    if !viewModel.wantToReadBooks.isEmpty {
                        HorizontalBookShelf(
                            title: "欲读清单",
                            subtitle: "保存在这里的未来读物",
                            books: viewModel.wantToReadBooks,
                            onSelectBook: { book in
                                viewModel.selectedDetailBook = book
                            }
                        )
                    }

                    // 已完成书架
                    if !viewModel.finishedBooks.isEmpty {
                        HorizontalBookShelf(
                            title: "已读完",
                            subtitle: "你所完成的阅读成就",
                            books: viewModel.finishedBooks,
                            onSelectBook: { book in
                                viewModel.selectedDetailBook = book
                            }
                        )
                    }

                    Spacer().frame(height: 30)
                }
                .padding(.top, 10)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("阅读中")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
