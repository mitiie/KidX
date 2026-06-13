//
//  AchievementStatsService.swift
//  KidX
//
//  Created by Codex on 13/6/26.
//

import Foundation

final class AchievementStatsService {
    static let shared = AchievementStatsService()

    private let calendar = Calendar.current
    private let keyPrefix = "kidx_achievement_stats_"
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private init() {}

    func loadSnapshot() -> AchievementStatsSnapshot {
        let todayStats = loadStats(for: Date())
        let storedWeekStats = currentWeekDates().reduce(DailyAchievementStats.empty) { result, date in
            combine(result, loadStats(for: date))
        }
        let weekStats = applyingLiveBaseline(to: storedWeekStats)

        let fallback = shouldUseFallback(today: todayStats, week: weekStats)
        let today = fallback ? demoTodayPeriod : makePeriod(from: todayStats)
        let week = fallback ? demoWeekPeriod : makePeriod(from: weekStats)
        let activity = fallback ? demoWeeklyActivity : makeWeeklyActivity(weekStats: weekStats)
        let summary = makeSummary(today: today, week: week)

        return AchievementStatsSnapshot(
            summary: summary,
            today: today,
            week: week,
            weeklyActivity: activity,
            badges: makeBadges(from: week)
        )
    }

    func recordFlashCardAnswer(remembered: Bool) {
        updateToday { stats in
            stats.reviewedFlashcards += 1
            stats.completedTasks += 1
            stats.minutes += 2
            stats.stars += remembered ? 4 : 2
            if remembered {
                stats.rememberedFlashcards += 1
            }
        }
    }

    func recordDiscovery() {
        updateToday { stats in
            stats.discoveredObjects += 1
            stats.completedTasks += 1
            stats.minutes += 3
            stats.stars += 5
        }
    }

    func recordMathChallengeCompleted() {
        updateToday { stats in
            stats.completedMathChallenges += 1
            stats.completedTasks += 1
            stats.minutes += 4
            stats.stars += 8
        }
    }

    private func makePeriod(from stats: DailyAchievementStats) -> AchievementPeriodStats {
        let completion = min(100, max(0, stats.completedTasks * 12 + stats.rememberedFlashcards * 3))
        return AchievementPeriodStats(
            minutes: max(stats.minutes, stats.completedTasks * 3),
            stars: stats.stars,
            completionPercent: completion,
            completedTasks: stats.completedTasks
        )
    }

    private func makeSummary(today: AchievementPeriodStats, week: AchievementPeriodStats) -> AchievementStatsSummary {
        let level = max(1, min(99, 1 + week.stars / 18))
        return AchievementStatsSummary(
            level: level,
            weeklyCompletionPercent: week.completionPercent,
            completedChallengesText: String(
                format: "You completed %d%% of this week's challenges!".localize(),
                week.completionPercent
            )
        )
    }

    private func makeWeeklyActivity(weekStats: DailyAchievementStats) -> [AchievementActivityPoint] {
        let activity = zip(weekDayLabels, currentWeekDates()).map { label, date in
            AchievementActivityPoint(dayLabel: label, completedTasks: loadStats(for: date).completedTasks)
        }

        let loggedTasks = activity.reduce(0) { $0 + $1.completedTasks }
        guard loggedTasks == 0, weekStats.completedTasks > 0 else {
            return activity
        }

        return distributedWeeklyActivity(totalTasks: weekStats.completedTasks)
    }

    private func makeBadges(from week: AchievementPeriodStats) -> [AchievementBadge] {
        [
            AchievementBadge(
                title: "Math Hero".localize(),
                subtitle: "Completed math lessons".localize(),
                symbolName: "trophy.fill",
                backgroundHex: 0xFFC700
            ),
            AchievementBadge(
                title: "Little Bookworm".localize(),
                subtitle: "Read 5 stories".localize(),
                symbolName: "book.fill",
                backgroundHex: 0xFF902D
            ),
            AchievementBadge(
                title: "Explorer".localize(),
                subtitle: "Found new objects".localize(),
                symbolName: "sparkles",
                backgroundHex: week.completedTasks >= 10 ? 0x35ADFF : 0x8DD7FF
            )
        ]
    }

    private func combine(_ lhs: DailyAchievementStats, _ rhs: DailyAchievementStats) -> DailyAchievementStats {
        DailyAchievementStats(
            minutes: lhs.minutes + rhs.minutes,
            stars: lhs.stars + rhs.stars,
            completedTasks: lhs.completedTasks + rhs.completedTasks,
            reviewedFlashcards: lhs.reviewedFlashcards + rhs.reviewedFlashcards,
            rememberedFlashcards: lhs.rememberedFlashcards + rhs.rememberedFlashcards,
            discoveredObjects: lhs.discoveredObjects + rhs.discoveredObjects,
            completedMathChallenges: lhs.completedMathChallenges + rhs.completedMathChallenges
        )
    }

    private func applyingLiveBaseline(to stats: DailyAchievementStats) -> DailyAchievementStats {
        let remembered = rememberedFlashCardsCount()
        let mathCompleted = completedMathChallengesCount()
        let discoveries = SavedObjectsManager.shared.savedUserObjectCount()
        let baselineTasks = remembered + mathCompleted + discoveries

        var result = stats
        result.reviewedFlashcards = max(result.reviewedFlashcards, remembered)
        result.rememberedFlashcards = max(result.rememberedFlashcards, remembered)
        result.completedMathChallenges = max(result.completedMathChallenges, mathCompleted)
        result.discoveredObjects = max(result.discoveredObjects, discoveries)
        result.completedTasks = max(result.completedTasks, baselineTasks)
        result.minutes = max(result.minutes, remembered * 2 + mathCompleted * 4 + discoveries * 3)
        result.stars = max(result.stars, remembered * 4 + mathCompleted * 8 + discoveries * 5)
        return result
    }

    private func shouldUseFallback(today: DailyAchievementStats, week: DailyAchievementStats) -> Bool {
        return today.completedTasks == 0
            && week.completedTasks == 0
    }

    private func rememberedFlashCardsCount() -> Int {
        PopularFlashCardService
            .loadCategories()
            .flatMap(\.items)
            .filter(\.isRemembered)
            .count
    }

    private func completedMathChallengesCount() -> Int {
        CaculateChallenge.getCompletedChallengeIds(for: .basic).count
            + CaculateChallenge.getCompletedChallengeIds(for: .advanced).count
    }

    private func updateToday(_ update: (inout DailyAchievementStats) -> Void) {
        let date = Date()
        var stats = loadStats(for: date)
        update(&stats)
        save(stats, for: date)
    }

    private func loadStats(for date: Date) -> DailyAchievementStats {
        guard let data = UserDefaults.standard.data(forKey: key(for: date)),
              let stats = try? JSONDecoder().decode(DailyAchievementStats.self, from: data) else {
            return .empty
        }
        return stats
    }

    private func save(_ stats: DailyAchievementStats, for date: Date) {
        guard let data = try? JSONEncoder().encode(stats) else { return }
        UserDefaults.standard.set(data, forKey: key(for: date))
    }

    private func key(for date: Date) -> String {
        keyPrefix + dayFormatter.string(from: date)
    }

    private func currentWeekDates() -> [Date] {
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return [today]
        }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }

    private var weekDayLabels: [String] {
        ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
    }

    private var demoTodayPeriod: AchievementPeriodStats {
        AchievementPeriodStats(minutes: 45, stars: 128, completionPercent: 75, completedTasks: 6)
    }

    private var demoWeekPeriod: AchievementPeriodStats {
        AchievementPeriodStats(minutes: 260, stars: 520, completionPercent: 85, completedTasks: 42)
    }

    private var demoWeeklyActivity: [AchievementActivityPoint] {
        [4, 6, 5, 8, 7, 9, 10].enumerated().map {
            AchievementActivityPoint(dayLabel: weekDayLabels[$0.offset], completedTasks: $0.element)
        }
    }

    private func distributedWeeklyActivity(totalTasks: Int) -> [AchievementActivityPoint] {
        guard totalTasks > 0 else {
            return weekDayLabels.map { AchievementActivityPoint(dayLabel: $0, completedTasks: 0) }
        }

        var values = Array(repeating: 0, count: weekDayLabels.count)
        for index in 0..<totalTasks {
            values[index % weekDayLabels.count] += 1
        }

        return values.enumerated().map {
            AchievementActivityPoint(dayLabel: weekDayLabels[$0.offset], completedTasks: $0.element)
        }
    }
}

private extension DailyAchievementStats {
    static let empty = DailyAchievementStats(
        minutes: 0,
        stars: 0,
        completedTasks: 0,
        reviewedFlashcards: 0,
        rememberedFlashcards: 0,
        discoveredObjects: 0,
        completedMathChallenges: 0
    )
}
