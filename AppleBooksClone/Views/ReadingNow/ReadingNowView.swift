import SwiftUI

public struct ReadingNowView: View {
    @ObservedObject public var viewModel: BooksViewModel
    private let weekDays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]

    public var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        // 顶部“探索书店”液态玻璃胶囊按钮
                        Button(action: {}) {
                            HStack {
                                Spacer()
                                Text("探索书店")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .frame(height: 48)
                            .liquidGlassPill(cornerRadius: 24, specularOpacity: 0.35, shadowRadius: 10)
                        }
                        .buttonStyle(.liquidSpring)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)

                        // 连续阅读周记录打卡专区
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                ForEach(Array(weekDays.enumerated()), id: \.offset) { index, day in
                                    let isCompleted = index <= 4 // 周日到周四已打卡
                                    VStack(spacing: 8) {
                                        Text(day)
                                            .font(.system(size: 11, weight: .regular))
                                            .foregroundColor(.white.opacity(0.6))

                                        ZStack {
                                            Circle()
                                                .fill(isCompleted ? Color.white.opacity(0.2) : Color.white.opacity(0.06))
                                                .frame(width: 38, height: 38)
                                                .overlay(
                                                    Circle()
                                                        .stroke(
                                                            isCompleted ? Color.white.opacity(0.6) : Color.white.opacity(0.12),
                                                            lineWidth: 0.8
                                                        )
                                                )

                                            if isCompleted {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)

                            VStack(spacing: 4) {
                                Text("开启连续阅读新记录")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)

                                Text("你的记录：\(viewModel.readingGoal.streakDays) 天。")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .liquidGlassCard(cornerRadius: 20, specularOpacity: 0.3)
                        .padding(.horizontal, 20)

                        // 今年读过的图书板块 (对应视频 frame_01)
                        VStack(alignment: .leading, spacing: 14) {
                            Text("今年读过的图书")
                                .font(.system(size: 19, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    // 已读第1本
                                    if let finishedBook = viewModel.finishedBooks.first ?? viewModel.books.first {
                                        ZStack(alignment: .bottomTrailing) {
                                            BookCoverView(book: finishedBook, width: 120, height: 180, cornerRadius: 8)

                                            // 蓝色对勾达成圆标
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.cyan)
                                                .background(Circle().fill(Color.white).frame(width: 20, height: 20))
                                                .offset(x: -6, y: -6)
                                        }
                                    }

                                    // 目标卡片 2
                                    goalSlotCard(number: 2)

                                    // 目标卡片 3
                                    goalSlotCard(number: 3)
                                }
                                .padding(.horizontal, 20)
                            }

                            // 引导文案
                            HStack(spacing: 4) {
                                Spacer()
                                Text("再读 2 本图书即可达成目标")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                            }
                            .padding(.top, 6)

                            Text("继续阅读！")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(maxWidth: .infinity)
                        }

                        // 正在阅读书籍卡片
                        if !viewModel.currentlyReadingBooks.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("正在阅读")
                                    .font(.system(size: 19, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)

                                ForEach(viewModel.currentlyReadingBooks) { book in
                                    CurrentlyReadingCard(
                                        book: book,
                                        onResume: { viewModel.activeReadingBook = book },
                                        onDetail: { viewModel.selectedDetailBook = book }
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                        }

                        // 条款与条件
                        HStack(spacing: 4) {
                            Text("条款与条件")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.4))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 90) // 避开底部悬浮导航栏
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func goalSlotCard(number: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(white: 0.12).opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 0.8)
                )

            Text("\(number)")
                .font(.system(size: 42, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.2))
        }
        .frame(width: 120, height: 180)
    }
}
