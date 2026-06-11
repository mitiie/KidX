//
//  CaculateViewModel.swift
//  KidX
//
//  Created by mitie on 11/6/26.
//

import Foundation
import CoreVideo
import FirebaseDatabase

class CaculateViewModel {
    
    // MARK: - Properties
    private let navigation: NavigationState<MainRoute>
    private let predictor = MNISTDigitPredictor()
    
    private(set) var challenges: [CaculateChallenge] = []
    private(set) var currentIndex: Int = 0
    
    // Callbacks
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(navigation: NavigationState<MainRoute>) {
        self.navigation = navigation
    }
    
    // MARK: - Navigation
    func navigateBack() {
        navigation.pop()
    }
    
    // MARK: - Data Loading
    func loadChallenges() {
        let ref = Database.database().reference().child("caculate_challenges")
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            var rawList: [[String: Any]] = []
            
            if let value = snapshot.value {
                if let dict = value as? [String: [String: Any]] {
                    rawList = Array(dict.values)
                } else if let array = value as? [[String: Any]] {
                    rawList = array
                } else if let array = value as? [Any] {
                    rawList = array.compactMap { $0 as? [String: Any] }
                } else if let dict = value as? [String: Any] {
                    rawList = dict.values.compactMap { $0 as? [String: Any] }
                }
            }
            
            if rawList.isEmpty {
                print("Firebase snapshot is empty or invalid format. Using local mock data.")
                self.loadMockData()
                return
            }
            
            do {
                let completedIds = CaculateChallenge.getCompletedChallengeIds()
                let jsonData = try JSONSerialization.data(withJSONObject: rawList, options: [])
                var decoded = try JSONDecoder().decode([CaculateChallenge].self, from: jsonData)
                
                decoded.sort { $0.level < $1.level }
                self.challenges = decoded.map { item in
                    var updated = item
                    updated.isCompleted = completedIds.contains(item.id)
                    return updated
                }
                
                // Find the first uncompleted challenge index
                if let firstUncompleted = self.challenges.firstIndex(where: { !$0.isCompleted }) {
                    self.currentIndex = firstUncompleted
                } else {
                    self.currentIndex = 0 // default to first if all completed
                }
                
                self.onDataLoaded?()
            } catch {
                print("Failed to decode Firebase math challenges: \(error). Using mock.")
                self.loadMockData()
            }
        } withCancel: { [weak self] error in
            print("Failed to fetch Firebase math challenges: \(error.localizedDescription). Using mock.")
            self?.loadMockData()
        }
    }
    
    private func loadMockData() {
        let completedIds = CaculateChallenge.getCompletedChallengeIds()
        let mockList: [CaculateChallenge] = [
            CaculateChallenge(id: "c1", level: 1, operand1: 3, operand2: 2, operation: "+", result: 5),
            CaculateChallenge(id: "c2", level: 2, operand1: 6, operand2: 3, operation: "+", result: 9),
            CaculateChallenge(id: "c3", level: 3, operand1: 8, operand2: 5, operation: "-", result: 3),
            CaculateChallenge(id: "c4", level: 4, operand1: 4, operand2: 4, operation: "+", result: 8),
            CaculateChallenge(id: "c5", level: 5, operand1: 9, operand2: 7, operation: "-", result: 2)
        ]
        
        self.challenges = mockList.map { item in
            var updated = item
            updated.isCompleted = completedIds.contains(item.id)
            return updated
        }
        
        if let firstUncompleted = self.challenges.firstIndex(where: { !$0.isCompleted }) {
            self.currentIndex = firstUncompleted
        } else {
            self.currentIndex = 0
        }
        
        self.onDataLoaded?()
    }
    
    // MARK: - Game Control
    var currentChallenge: CaculateChallenge? {
        guard currentIndex >= 0, currentIndex < challenges.count else { return nil }
        return challenges[currentIndex]
    }
    
    func nextChallenge() -> Bool {
        if currentIndex < challenges.count - 1 {
            currentIndex += 1
            return true
        }
        return false // reached the end
    }
    
    func resetProgress() {
        CaculateChallenge.clearProgress()
        loadChallenges()
    }
    
    // MARK: - Prediction / Verification
    func checkAnswer(pixelBuffer: CVPixelBuffer, completion: @escaping (Bool, String) -> Void) {
        guard let challenge = currentChallenge else {
            completion(false, "?")
            return
        }
        
        do {
            let prediction = try predictor.predict(from: pixelBuffer)
            let isCorrect = (prediction.digit == String(challenge.result))
            
            if isCorrect {
                // Mark complete in local DB
                CaculateChallenge.setChallengeCompleted(id: challenge.id)
                if currentIndex < challenges.count {
                    challenges[currentIndex].isCompleted = true
                }
            }
            
            completion(isCorrect, prediction.digit)
        } catch {
            print("Failed to run prediction: \(error)")
            completion(false, "?")
        }
    }
}
