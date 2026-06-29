//
//  AchievementStatsModels.swift
//  KidX
//
//  Created by mt on 13/6/26.
//

import Foundation

enum AchievementStatsRange {
    case today
    case week
}

struct AchievementStatsSnapshot {
    let summary: AchievementStatsSummary
    let today: AchievementPeriodStats
    let week: AchievementPeriodStats
    let weeklyActivity: [AchievementActivityPoint]
    let badges: [AchievementBadge]
}

struct AchievementStatsSummary {
    let level: Int
    let weeklyCompletionPercent: Int
    let completedChallengesText: String
}

struct AchievementPeriodStats {
    let minutes: Int
    let stars: Int
    let completionPercent: Int
    let completedTasks: Int
}

struct AchievementActivityPoint {
    let dayLabel: String
    let completedTasks: Int
}

struct AchievementBadge {
    let title: String
    let subtitle: String
    let symbolName: String
    let backgroundHex: UInt32
}

struct DailyAchievementStats: Codable {
    var minutes: Int
    var stars: Int
    var completedTasks: Int
    var reviewedFlashcards: Int
    var rememberedFlashcards: Int
    var discoveredObjects: Int
    var completedMathChallenges: Int
}
