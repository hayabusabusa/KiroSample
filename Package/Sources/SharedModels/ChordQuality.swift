//
//  ChordQuality.swift
//  SharedModels
//
//  Created by Claude on 2025/07/21.
//

import Foundation

/// コードの品質（メジャー、マイナーなど）を表すenum
public enum ChordQuality: Equatable, Hashable, CaseIterable, Sendable {
    case major
    case minor
    case diminished
    case augmented
    case sus2
    case sus4
    case dominant7
    case major7
    case minor7
    case diminished7
    case halfDiminished7
    case augmented7
    case minorMajor7
    case add9
    case major9
    case minor9
    case dominant9
    case major11
    case minor11
    case dominant11
    case major13
    case minor13
    case dominant13
    
    /// コード記号での表現
    public var symbol: String {
        switch self {
        case .major: return ""
        case .minor: return "m"
        case .diminished: return "dim"
        case .augmented: return "aug"
        case .sus2: return "sus2"
        case .sus4: return "sus4"
        case .dominant7: return "7"
        case .major7: return "maj7"
        case .minor7: return "m7"
        case .diminished7: return "dim7"
        case .halfDiminished7: return "m7b5"
        case .augmented7: return "aug7"
        case .minorMajor7: return "mMaj7"
        case .add9: return "add9"
        case .major9: return "maj9"
        case .minor9: return "m9"
        case .dominant9: return "9"
        case .major11: return "maj11"
        case .minor11: return "m11"
        case .dominant11: return "11"
        case .major13: return "maj13"
        case .minor13: return "m13"
        case .dominant13: return "13"
        }
    }
    
    /// 日本語での説明
    public var japaneseDescription: String {
        switch self {
        case .major: return "長三和音"
        case .minor: return "短三和音"
        case .diminished: return "減三和音"
        case .augmented: return "増三和音"
        case .sus2: return "サスペンデッド2"
        case .sus4: return "サスペンデッド4"
        case .dominant7: return "属7"
        case .major7: return "長7"
        case .minor7: return "短7"
        case .diminished7: return "減7"
        case .halfDiminished7: return "半減7"
        case .augmented7: return "増7"
        case .minorMajor7: return "短長7"
        case .add9: return "アド9"
        case .major9: return "長9"
        case .minor9: return "短9"
        case .dominant9: return "属9"
        case .major11: return "長11"
        case .minor11: return "短11"
        case .dominant11: return "属11"
        case .major13: return "長13"
        case .minor13: return "短13"
        case .dominant13: return "属13"
        }
    }
    
    /// このコード品質に含まれる音程（半音単位、ルートからの距離）
    public var intervals: [Int] {
        switch self {
        case .major:
            return [0, 4, 7] // Root, Major 3rd, Perfect 5th
        case .minor:
            return [0, 3, 7] // Root, Minor 3rd, Perfect 5th
        case .diminished:
            return [0, 3, 6] // Root, Minor 3rd, Diminished 5th
        case .augmented:
            return [0, 4, 8] // Root, Major 3rd, Augmented 5th
        case .sus2:
            return [0, 2, 7] // Root, Major 2nd, Perfect 5th
        case .sus4:
            return [0, 5, 7] // Root, Perfect 4th, Perfect 5th
        case .dominant7:
            return [0, 4, 7, 10] // Root, Major 3rd, Perfect 5th, Minor 7th
        case .major7:
            return [0, 4, 7, 11] // Root, Major 3rd, Perfect 5th, Major 7th
        case .minor7:
            return [0, 3, 7, 10] // Root, Minor 3rd, Perfect 5th, Minor 7th
        case .diminished7:
            return [0, 3, 6, 9] // Root, Minor 3rd, Diminished 5th, Diminished 7th
        case .halfDiminished7:
            return [0, 3, 6, 10] // Root, Minor 3rd, Diminished 5th, Minor 7th
        case .augmented7:
            return [0, 4, 8, 10] // Root, Major 3rd, Augmented 5th, Minor 7th
        case .minorMajor7:
            return [0, 3, 7, 11] // Root, Minor 3rd, Perfect 5th, Major 7th
        case .add9:
            return [0, 4, 7, 14] // Root, Major 3rd, Perfect 5th, Major 9th
        case .major9:
            return [0, 4, 7, 11, 14] // Root, Major 3rd, Perfect 5th, Major 7th, Major 9th
        case .minor9:
            return [0, 3, 7, 10, 14] // Root, Minor 3rd, Perfect 5th, Minor 7th, Major 9th
        case .dominant9:
            return [0, 4, 7, 10, 14] // Root, Major 3rd, Perfect 5th, Minor 7th, Major 9th
        case .major11:
            return [0, 4, 7, 11, 14, 17] // Root, Major 3rd, Perfect 5th, Major 7th, Major 9th, Perfect 11th
        case .minor11:
            return [0, 3, 7, 10, 14, 17] // Root, Minor 3rd, Perfect 5th, Minor 7th, Major 9th, Perfect 11th
        case .dominant11:
            return [0, 4, 7, 10, 14, 17] // Root, Major 3rd, Perfect 5th, Minor 7th, Major 9th, Perfect 11th
        case .major13:
            return [0, 4, 7, 11, 14, 21] // Root, Major 3rd, Perfect 5th, Major 7th, Major 9th, Major 13th
        case .minor13:
            return [0, 3, 7, 10, 14, 21] // Root, Minor 3rd, Perfect 5th, Minor 7th, Major 9th, Major 13th
        case .dominant13:
            return [0, 4, 7, 10, 14, 21] // Root, Major 3rd, Perfect 5th, Minor 7th, Major 9th, Major 13th
        }
    }
    
    /// このコード品質が7thコードかどうか
    public var isSeventh: Bool {
        switch self {
        case .dominant7, .major7, .minor7, .diminished7, .halfDiminished7, .augmented7, .minorMajor7:
            return true
        default:
            return false
        }
    }
    
    /// このコード品質が拡張コード（9th, 11th, 13th）かどうか
    public var isExtended: Bool {
        switch self {
        case .add9, .major9, .minor9, .dominant9, .major11, .minor11, .dominant11, .major13, .minor13, .dominant13:
            return true
        default:
            return false
        }
    }
}