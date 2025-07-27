//
//  KeyMode.swift
//  SharedModels
//
//  Created by Claude on 2025/07/21.
//

import Foundation

/// キーのモード（長調・短調）を表すenum
public enum KeyMode: String, CaseIterable, Equatable, Hashable, Sendable {
    case major = "Major"
    case minor = "minor"
    
    /// キーモードの記号表現
    public var symbol: String {
        switch self {
        case .major: return ""
        case .minor: return "m"
        }
    }
    
    /// 日本語での表現
    public var japaneseDescription: String {
        switch self {
        case .major: return "長調"
        case .minor: return "短調"
        }
    }
    
    /// このモードのスケールの音程パターン（半音単位）
    public var scaleIntervals: [Int] {
        switch self {
        case .major:
            return [0, 2, 4, 5, 7, 9, 11] // W-W-H-W-W-W-H
        case .minor:
            return [0, 2, 3, 5, 7, 8, 10] // W-H-W-W-H-W-W (ナチュラルマイナー)
        }
    }
}