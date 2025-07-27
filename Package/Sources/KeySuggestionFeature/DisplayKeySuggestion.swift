//
//  DisplayKeySuggestion.swift
//  KeySuggestionFeature
//
//  Created by Shunya Yamada on 2025/07/27.
//

import Foundation
import Domain
import SharedModels

/// 表示用のキー提案データ
public struct DisplayKeySuggestion {
    /// 元のキー提案
    public let suggestion: KeySuggestion
    /// 選択状態
    public let isSelected: Bool
    /// 信頼度レベル
    public let confidenceLevel: ConfidenceLevel
    /// 詳細な理由説明（表示設定による）
    public let detailedReason: String?
    
    public init(
        suggestion: KeySuggestion,
        isSelected: Bool,
        confidenceLevel: ConfidenceLevel,
        detailedReason: String?
    ) {
        self.suggestion = suggestion
        self.isSelected = isSelected
        self.confidenceLevel = confidenceLevel
        self.detailedReason = detailedReason
    }
}

/// 信頼度レベル
public enum ConfidenceLevel: String, CaseIterable {
    case veryHigh = "非常に高い"
    case high = "高い"
    case medium = "普通"
    case low = "低い"
    case veryLow = "非常に低い"
    
    public var description: String {
        return rawValue
    }
    
    /// UI表示用の色を示すヒント
    public var colorHint: String {
        switch self {
        case .veryHigh:
            return "green"
        case .high:
            return "blue"
        case .medium:
            return "orange"
        case .low:
            return "yellow"
        case .veryLow:
            return "red"
        }
    }
}