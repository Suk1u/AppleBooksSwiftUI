import Foundation

public struct ReadingGoal: Codable {
    public var dailyTargetMinutes: Int
    public var todayMinutes: Int
    public var streakDays: Int
    public var lastUpdatedDate: Date

    public init(
        dailyTargetMinutes: Int = 30,
        todayMinutes: Int = 18,
        streakDays: Int = 7,
        lastUpdatedDate: Date = Date()
    ) {
        self.dailyTargetMinutes = dailyTargetMinutes
        self.todayMinutes = todayMinutes
        self.streakDays = streakDays
        self.lastUpdatedDate = lastUpdatedDate
    }

    public var progress: Double {
        guard dailyTargetMinutes > 0 else { return 0 }
        return min(Double(todayMinutes) / Double(dailyTargetMinutes), 1.0)
    }

    public var remainingMinutes: Int {
        max(dailyTargetMinutes - todayMinutes, 0)
    }

    public var isCompleted: Bool {
        todayMinutes >= dailyTargetMinutes
    }
}
