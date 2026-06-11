//
//  CaculateChallenge.swift
//  KidX
//
//  Created by mitie on 11/6/26.
//

import Foundation

struct CaculateChallenge: Codable {
    let id: String
    let level: Int
    let operand1: Int
    let operand2: Int
    let operation: String
    let result: Int
    var isCompleted: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case level
        case operand1
        case operand2
        case operation
        case result
    }
    
    init(id: String, level: Int, operand1: Int, operand2: Int, operation: String, result: Int, isCompleted: Bool = false) {
        self.id = id
        self.level = level
        self.operand1 = operand1
        self.operand2 = operand2
        self.operation = operation
        self.result = result
        self.isCompleted = isCompleted
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        // Suppport decoding from standard types
        if let levelInt = try? container.decode(Int.self, forKey: .level) {
            level = levelInt
        } else if let levelStr = try? container.decode(String.self, forKey: .level), let levelInt = Int(levelStr) {
            level = levelInt
        } else {
            level = 1
        }
        
        if let op1Int = try? container.decode(Int.self, forKey: .operand1) {
            operand1 = op1Int
        } else if let op1Str = try? container.decode(String.self, forKey: .operand1), let op1Int = Int(op1Str) {
            operand1 = op1Int
        } else {
            operand1 = 0
        }
        
        if let op2Int = try? container.decode(Int.self, forKey: .operand2) {
            operand2 = op2Int
        } else if let op2Str = try? container.decode(String.self, forKey: .operand2), let op2Int = Int(op2Str) {
            operand2 = op2Int
        } else {
            operand2 = 0
        }
        
        operation = try container.decode(String.self, forKey: .operation)
        
        if let resultInt = try? container.decode(Int.self, forKey: .result) {
            result = resultInt
        } else if let resultStr = try? container.decode(String.self, forKey: .result), let resultInt = Int(resultStr) {
            result = resultInt
        } else {
            result = 0
        }
        
        isCompleted = false
    }
    
    static func getCompletedChallengeIds() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "completed_caculate_challenges") ?? []
    }
    
    static func setChallengeCompleted(id: String) {
        var completed = getCompletedChallengeIds()
        if !completed.contains(id) {
            completed.append(id)
            UserDefaults.standard.set(completed, forKey: "completed_caculate_challenges")
        }
    }
    
    static func clearProgress() {
        UserDefaults.standard.removeObject(forKey: "completed_caculate_challenges")
    }
}
