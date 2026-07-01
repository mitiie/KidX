//
//  AchievementStatsViewModel.swift
//  KidX
//
//  Created by mt on 13/6/26.
//

import Foundation

final class AchievementStatsViewModel {
    private let navigation: NavigationState<MainRoute>
    private let service: AchievementStatsService
    private var snapshot: AchievementStatsSnapshot
    private(set) var selectedRange: AchievementStatsRange = .today

    init(navigation: NavigationState<MainRoute>, service: AchievementStatsService = .shared) {
        self.navigation = navigation
        self.service = service
        self.snapshot = service.loadSnapshotFromCache()
    }

    var summary: AchievementStatsSummary {
        snapshot.summary
    }

    var selectedStats: AchievementPeriodStats {
        selectedRange == .today ? snapshot.today : snapshot.week
    }

    var weeklyActivity: [AchievementActivityPoint] {
        snapshot.weeklyActivity
    }

    var badges: [AchievementBadge] {
        snapshot.badges
    }

    func selectRange(_ range: AchievementStatsRange) {
        selectedRange = range
    }

    func reload(completion: @escaping () -> Void) {
        service.loadSnapshot { [weak self] freshSnapshot in
            self?.snapshot = freshSnapshot
            completion()
        }
    }

    func navigateBack() {
        navigation.pop()
    }
}

