//
//  MobileNetLabelTranslator.swift
//  KidX
//
//  Created by mt on 7/6/26.
//

import Foundation

enum MobileNetLabelTranslator {
    static func vietnameseName(for rawLabel: String) -> String {
        let label = rawLabel.trimmingCharacters(in: .whitespacesAndNewlines)

        if let name = MobileNetVietnameseOverrides.values[label] {
            return name
        }

        if let name = MobileNetVietnameseDictionary.values[label] {
            return name
        }

        return "vật thể"
    }

    static var hasFullCoverage: Bool {
        MobileNetLabels.all.allSatisfy {
            MobileNetVietnameseOverrides.values[$0] != nil || MobileNetVietnameseDictionary.values[$0] != nil
        }
    }
}
