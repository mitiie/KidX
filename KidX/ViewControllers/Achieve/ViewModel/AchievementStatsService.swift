//
//  AchievementStatsService.swift
//  KidX
//
//  Created by Codex on 13/6/26.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class AchievementStatsService {
    static let shared = AchievementStatsService()

    private let calendar = Calendar.current
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    /// Cache local để UI luôn responsive
    private var localCache: [String: DailyAchievementStats] = [:]

    private init() {}

    // MARK: - Firebase Reference

    private var userStatsRef: DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Database.database().reference().child("users").child(uid).child("achievement_stats")
    }

    // MARK: - Load Snapshot (Async)

    /// Load toàn bộ snapshot thống kê từ Firebase (async)
    func loadSnapshot(completion: @escaping (AchievementStatsSnapshot) -> Void) {
        guard let ref = userStatsRef else {
            // Không có user đăng nhập → trả demo data
            completion(makeFallbackSnapshot())
            return
        }

        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }

            var weekStats = DailyAchievementStats.empty
            let weekDates = self.currentWeekDates()
            let todayKey = self.dayFormatter.string(from: Date())

            var todayStats = DailyAchievementStats.empty

            if let dict = snapshot.value as? [String: [String: Any]] {
                for date in weekDates {
                    let dateKey = self.dayFormatter.string(from: date)
                    if let dayDict = dict[dateKey],
                       let stats = self.decodeDailyStats(from: dayDict) {
                        self.localCache[dateKey] = stats
                        weekStats = self.combine(weekStats, stats)
                        if dateKey == todayKey {
                            todayStats = stats
                        }
                    }
                }
            }

            let result = self.buildSnapshot(todayStats: todayStats, weekStats: weekStats)
            completion(result)
        } withCancel: { error in
            print("Failed to load achievement stats: \(error.localizedDescription)")
            completion(self.makeFallbackSnapshot())
        }
    }

    /// Load đồng bộ từ cache local (cho các caller cần sync nhanh)
    func loadSnapshotFromCache() -> AchievementStatsSnapshot {
        let todayKey = dayFormatter.string(from: Date())
        let todayStats = localCache[todayKey] ?? .empty
        let weekStats = currentWeekDates().reduce(DailyAchievementStats.empty) { result, date in
            let key = dayFormatter.string(from: date)
            return combine(result, localCache[key] ?? .empty)
        }
        return buildSnapshot(todayStats: todayStats, weekStats: weekStats)
    }

    // MARK: - Record Actions

    func recordFlashCardAnswer(remembered: Bool) {
        updateToday { stats in
            stats.reviewedFlashcards += 1
            stats.completedTasks += 1
            stats.minutes += 2
            stats.stars += remembered ? 1 : 0
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
            stats.stars += 3
        }
    }

    func recordMathChallengeCompleted(isAdvanced: Bool) {
        updateToday { stats in
            stats.completedMathChallenges += 1
            stats.completedTasks += 1
            stats.minutes += 4
            stats.stars += isAdvanced ? 5 : 3
        }
    }

    // MARK: - Private Helpers

    private func updateToday(_ update: (inout DailyAchievementStats) -> Void) {
        let dateKey = dayFormatter.string(from: Date())
        var stats = localCache[dateKey] ?? .empty
        update(&stats)
        localCache[dateKey] = stats
        saveToFirebase(stats, dateKey: dateKey)
    }

    private func saveToFirebase(_ stats: DailyAchievementStats, dateKey: String) {
        guard let ref = userStatsRef else { return }

        let payload: [String: Any] = [
            "minutes": stats.minutes,
            "stars": stats.stars,
            "completedTasks": stats.completedTasks,
            "reviewedFlashcards": stats.reviewedFlashcards,
            "rememberedFlashcards": stats.rememberedFlashcards,
            "discoveredObjects": stats.discoveredObjects,
            "completedMathChallenges": stats.completedMathChallenges
        ]

        ref.child(dateKey).setValue(payload) { error, _ in
            if let error = error {
                print("Failed to save stats to Firebase: \(error.localizedDescription)")
            }
        }
    }

    private func decodeDailyStats(from dict: [String: Any]) -> DailyAchievementStats? {
        return DailyAchievementStats(
            minutes: dict["minutes"] as? Int ?? 0,
            stars: dict["stars"] as? Int ?? 0,
            completedTasks: dict["completedTasks"] as? Int ?? 0,
            reviewedFlashcards: dict["reviewedFlashcards"] as? Int ?? 0,
            rememberedFlashcards: dict["rememberedFlashcards"] as? Int ?? 0,
            discoveredObjects: dict["discoveredObjects"] as? Int ?? 0,
            completedMathChallenges: dict["completedMathChallenges"] as? Int ?? 0
        )
    }

    private func buildSnapshot(todayStats: DailyAchievementStats, weekStats: DailyAchievementStats) -> AchievementStatsSnapshot {
        let fallback = todayStats.completedTasks == 0 && weekStats.completedTasks == 0

        let today = fallback ? demoTodayPeriod : makePeriod(from: todayStats)
        let week = fallback ? demoWeekPeriod : makePeriod(from: weekStats)
        let activity = fallback ? demoWeeklyActivity : makeWeeklyActivity()
        let summary = makeSummary(today: today, week: week)

        return AchievementStatsSnapshot(
            summary: summary,
            today: today,
            week: week,
            weeklyActivity: activity,
            badges: makeBadges(from: week)
        )
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

    private func makeWeeklyActivity() -> [AchievementActivityPoint] {
        zip(weekDayLabels, currentWeekDates()).map { label, date in
            let key = dayFormatter.string(from: date)
            let tasks = localCache[key]?.completedTasks ?? 0
            return AchievementActivityPoint(dayLabel: label, completedTasks: tasks)
        }
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

    private func makeFallbackSnapshot() -> AchievementStatsSnapshot {
        let today = demoTodayPeriod
        let week = demoWeekPeriod
        return AchievementStatsSnapshot(
            summary: makeSummary(today: today, week: week),
            today: today,
            week: week,
            weeklyActivity: demoWeeklyActivity,
            badges: makeBadges(from: week)
        )
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

