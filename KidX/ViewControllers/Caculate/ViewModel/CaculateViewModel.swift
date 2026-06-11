//
//  CaculateViewModel.swift
//  KidX
//
//  Created by mitie on 11/6/26.
//

import Foundation
import CoreVideo

class CaculateViewModel {
    
    // MARK: - Properties
    private let navigation: NavigationState<MainRoute>
    private let predictor = MNISTDigitPredictor()
    let difficulty: CaculateDifficulty
    
    private(set) var challenges: [CaculateChallenge] = []
    private(set) var currentIndex: Int = 0
    
    // Callbacks
    var onDataLoaded: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(navigation: NavigationState<MainRoute>, difficulty: CaculateDifficulty = .basic) {
        self.navigation = navigation
        self.difficulty = difficulty
    }
    
    // MARK: - Navigation
    func navigateBack() {
        navigation.pop()
    }
    
    // MARK: - Data Loading
    func loadChallenges() {
        let completedIds = CaculateChallenge.getCompletedChallengeIds(for: difficulty)
        var generatedList: [CaculateChallenge] = []
        
        for level in 1...10 {
            let challengeId = "\(difficulty == .basic ? "basic" : "advanced")_level_\(level)"
            let isCompleted = completedIds.contains(challengeId)
            
            let operand1: Int
            let operand2: Int
            let operation: String
            let result: Int
            
            if difficulty == .basic {
                let isPlus = Bool.random()
                operation = isPlus ? "+" : "-"
                if isPlus {
                    operand1 = Int.random(in: 0...9)
                    operand2 = Int.random(in: 0...(9 - operand1))
                    result = operand1 + operand2
                } else {
                    operand1 = Int.random(in: 0...9)
                    operand2 = Int.random(in: 0...operand1)
                    result = operand1 - operand2
                }
            } else {
                // Advanced mode: subtraction of 2-digit numbers yielding 1-digit result
                operation = "-"
                operand1 = Int.random(in: 10...99)
                let minOp2 = max(10, operand1 - 9)
                operand2 = Int.random(in: minOp2...operand1)
                result = operand1 - operand2
            }
            
            let challenge = CaculateChallenge(
                id: challengeId,
                level: level,
                operand1: operand1,
                operand2: operand2,
                operation: operation,
                result: result,
                isCompleted: isCompleted
            )
            generatedList.append(challenge)
        }
        
        self.challenges = generatedList
        
        // Find the first uncompleted challenge index
        if let firstUncompleted = self.challenges.firstIndex(where: { !$0.isCompleted }) {
            self.currentIndex = firstUncompleted
        } else {
            self.currentIndex = 0 // default to first if all completed
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
        CaculateChallenge.clearProgress(for: difficulty)
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
                CaculateChallenge.setChallengeCompleted(id: challenge.id, difficulty: difficulty)
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
