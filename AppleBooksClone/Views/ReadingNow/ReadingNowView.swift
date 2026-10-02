import SwiftUI

// MARK: - “阅读中 / 主页” 视图 (WWDC25 Liquid Glass 架构)

public struct ReadingNowView: View {
    @ObservedObject public var viewModel: BooksViewModel
    private let weekDays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        NavigationStack {
            ZStack {
                // 底层动态流体渐变背景（保持内容层不被玻璃化，由悬浮组件进行折射）
                DynamicGradientBackground()

                GlassEffectContainer {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            // 顶部“探索书店”液态玻璃胶囊按钮
                            Button(action: {}) {
                                HStack {
                                    Spacer()
                                    Text("探索书店")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .frame(height: 48)
                                .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
                            }
                            .buttonStyle(.glass)
                            .padding(.horizontal, 24)
                            .padding(.top, 12)

                            // 连续阅读周记录打卡专区 (液态玻璃卡片)
                            LiquidGlassCard(cornerRadius: 24) {
                                VStack(spacing: 12) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(weekDays.enumerated()), id: \.offset) { index, day in
                                            let isCompleted = index <= 4
                                            VStack(spacing: 8) {
                                                Text(day)
                                                    .font(.system(size: 11, weight: .regular))
                                                    .foregroundColor(.secondary)

                                                ZStack {
                                                    Circle()
                                                        .fill(isCompleted ? (colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.08)) : Color.clear)
                                                        .frame(width: 36, height: 36)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(isCompleted ? Color.primary.opacity(0.5) : Color.secondary.opacity(0.25), lineWidth: 1)
                                                        )

                                                    if isCompleted {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 13, weight: .bold))
                                                            .foregroundColor(.primary)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 4)

                                    VStack(spacing: 4) {
                                        Text("开启连续阅读新记录")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.primary)

                                        Text("你的记录：\(viewModel.readingGoal.streakDays) 天。")
                                            .font(.system(size: 13, weight: .regular))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.top, 4)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal, 20)

                            // 今年读过的图书板块 (对应视频 frame_01)
                            VStack(alignment: .leading, spacing: 14) {
                                Text("今年读过的图书")
                                    .font(.system(size: 19, weight: .bold))
                                    .foregroundColor(.primary)
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
                                        .foregroundColor(.primary)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                .padding(.top, 6)

                                Text("继续阅读！")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                            }

                            // 正在阅读书籍卡片
                            if !viewModel.currentlyReadingBooks.isEmpty {
                                VStack(alignment: .leading, spacing: 14) {
                                    Text("正在阅读")
                                        .font(.system(size: 19, weight: .bold))
                                        .foregroundColor(.primary)
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
                                    .foregroundColor(.secondary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 96) // 避让底部悬浮玻璃 TabBar
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func goalSlotCard(number: Int) -> some View {
        ZStack {
            Text("\(number)")
                .font(.system(size: 42, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary.opacity(0.5))
        }
        .frame(width: 120, height: 180)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
