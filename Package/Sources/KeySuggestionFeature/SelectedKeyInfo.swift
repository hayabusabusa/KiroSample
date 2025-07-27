//
//  SelectedKeyInfo.swift
//  KeySuggestionFeature
//
//  Created by Shunya Yamada on 2025/07/27.
//

import Foundation
import Domain
import SharedModels

/// 選択されたキーの詳細情報
public struct SelectedKeyInfo {
    /// 選択されたキー
    public let key: Key
    /// 関連するキー提案
    public let suggestion: KeySuggestion
    /// ダイアトニックコード一覧
    public let diatonicChords: [DiatonicChord]

    public init(
        key: Key,
        suggestion: KeySuggestion,
        diatonicChords: [DiatonicChord]
    ) {
        self.key = key
        self.suggestion = suggestion
        self.diatonicChords = diatonicChords
    }
}

// MARK: - Computed Properties

public extension SelectedKeyInfo {
    /// キーの基本情報
    var basicInfo: String {
        return "\(key.name) (\(key.mode == .major ? "メジャー" : "マイナー"))"
    }

    /// 選択理由の詳細
    var selectionReason: String {
        return suggestion.reason
    }

    /// 信頼度スコア
    var confidenceScore: Double {
        return suggestion.score
    }

    /// ダイアトニックコード名の一覧
    var chordNames: [String] {
        return diatonicChords.map { $0.chord.symbol }
    }

    /// ローマ数字表記の一覧
    var romanNumerals: [String] {
        return diatonicChords.map { $0.romanNumeral }
    }

    /// ハーモニック機能別のコード分類
    var chordsByFunction: [HarmonicFunction: [DiatonicChord]] {
        return Dictionary(grouping: diatonicChords) { $0.function }
    }
}
