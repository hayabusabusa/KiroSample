//
//  Note.swift
//  SharedModels
//
//  Created by Claude on 2025/07/21.
//

import Foundation

/// 音名を表すenum
public enum Note: String, CaseIterable, Equatable, Hashable, Sendable {
    case c = "C"
    case cSharp = "C#"
    case dFlat = "Db"
    case d = "D"
    case dSharp = "D#"
    case eFlat = "Eb"
    case e = "E"
    case f = "F"
    case fSharp = "F#"
    case gFlat = "Gb"
    case g = "G"
    case gSharp = "G#"
    case aFlat = "Ab"
    case a = "A"
    case aSharp = "A#"
    case bFlat = "Bb"
    case b = "B"
    
    /// 音名の文字列表現
    public var name: String { rawValue }
    
    /// 半音単位での音程値（Cを0とした場合の値）
    public var semitoneValue: Int {
        switch self {
        case .c: return 0
        case .cSharp, .dFlat: return 1
        case .d: return 2
        case .dSharp, .eFlat: return 3
        case .e: return 4
        case .f: return 5
        case .fSharp, .gFlat: return 6
        case .g: return 7
        case .gSharp, .aFlat: return 8
        case .a: return 9
        case .aSharp, .bFlat: return 10
        case .b: return 11
        }
    }
    
    /// 異名同音の音名を取得
    public var enharmonicEquivalent: Note? {
        switch self {
        case .cSharp: return .dFlat
        case .dFlat: return .cSharp
        case .dSharp: return .eFlat
        case .eFlat: return .dSharp
        case .fSharp: return .gFlat
        case .gFlat: return .fSharp
        case .gSharp: return .aFlat
        case .aFlat: return .gSharp
        case .aSharp: return .bFlat
        case .bFlat: return .aSharp
        default: return nil
        }
    }
    
    /// 自然音（シャープ・フラットでない音）かどうか
    public var isNatural: Bool {
        switch self {
        case .c, .d, .e, .f, .g, .a, .b:
            return true
        default:
            return false
        }
    }
    
    /// 半音単位で音程を上げた音名を取得
    /// - Parameter semitones: 上げる半音の数
    /// - Returns: 結果の音名
    public func transposed(by semitones: Int) -> Note {
        let allNotes = Note.allCases.filter { note in
            // 異名同音のうち、シャープ系を優先的に使用
            switch note {
            case .dFlat, .eFlat, .gFlat, .aFlat, .bFlat:
                return false
            default:
                return true
            }
        }
        
        let currentIndex = allNotes.firstIndex { $0.semitoneValue == self.semitoneValue } ?? 0
        let newIndex = (currentIndex + semitones) % allNotes.count
        let adjustedIndex = newIndex < 0 ? newIndex + allNotes.count : newIndex
        
        return allNotes[adjustedIndex]
    }
}