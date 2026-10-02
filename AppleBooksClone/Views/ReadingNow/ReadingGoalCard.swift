import SwiftUI

public struct ReadingGoalCard: View {
    public let goal: ReadingGoal

    public var body: some View {
        HStack(spacing: 20) {
            // 左侧环形进度
            ZStack {
                CircularProgressView(
                    progress: goal.progress,
                    lineWidth: 7,
                    primaryColor: Color.orange,
                    secondaryColor: Color.orange.opacity(0.15)
                )
                .frame(width: 58, height: 58)

                Image(systemName: "book.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.orange)
            }

            // 中间文案
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("今日阅读")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)

                    Text("\(goal.todayMinutes) / \(goal.dailyTargetMinutes) 分钟")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                }

                if goal.isCompleted {
                    Text("🎉 今日阅读目标已达成！太棒了！")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.green)
                } else {
                    Text("还差 \(goal.remainingMinutes) 分钟达成今日目标")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // 右侧连胜火焰
            VStack(spacing: 2) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.orange)
                Text("\(goal.streakDays) 天")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}
