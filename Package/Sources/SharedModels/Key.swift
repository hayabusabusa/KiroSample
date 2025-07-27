//
//  Key.swift
//  SharedModels
//
//  Created by Shunya Yamada on 2025/07/21.
//

import Foundation

/// 音楽のキーを表す構造体
public struct Key: Equatable, Hashable, Sendable {
    /// トニック（主音）
    public let tonic: Note
    
    /// キーのモード
    public let mode: KeyMode
    
    /// イニシャライザ
    /// - Parameters:
    ///   - tonic: トニック（主音）
    ///   - mode: キーのモード
    public init(tonic: Note, mode: KeyMode) {
        self.tonic = tonic
        self.mode = mode
    }
    
    /// キーの名前表現
    public var name: String {
        return "\(tonic.name) \(mode.rawValue)"
    }
    
    /// キーの短縮名表現
    public var shortName: String {
        return "\(tonic.name)\(mode.symbol)"
    }
    
    /// 日本語でのキー表現
    public var japaneseName: String {
        return "\(tonic.name)\(mode.japaneseDescription)"
    }
    
    /// このキーのスケールを構成する音名を取得
    public var scale: [Note] {
        var scaleNotes: [Note] = []
        
        for interval in mode.scaleIntervals {
            let noteValue = (tonic.semitoneValue + interval) % 12
            // 適切な異名同音を選択
            if let note = findAppropriateNote(for: noteValue, in: scaleNotes) {
                scaleNotes.append(note)
            }
        }
        
        return scaleNotes
    }
    
    /// このキーの調号（シャープ・フラットの数）を取得
    public var keySignature: KeySignature {
        let circleOfFifths: [(Note, KeyMode, Int)] = [
            // メジャーキー
            (.c, .major, 0),      // C Major
            (.g, .major, 1),      // G Major (1#)
            (.d, .major, 2),      // D Major (2#)
            (.a, .major, 3),      // A Major (3#)
            (.e, .major, 4),      // E Major (4#)
            (.b, .major, 5),      // B Major (5#)
            (.fSharp, .major, 6), // F# Major (6#)
            (.f, .major, -1),     // F Major (1b)
            (.bFlat, .major, -2), // Bb Major (2b)
            (.eFlat, .major, -3), // Eb Major (3b)
            (.aFlat, .major, -4), // Ab Major (4b)
            (.dFlat, .major, -5), // Db Major (5b)
            (.gFlat, .major, -6), // Gb Major (6b)
            
            // マイナーキー
            (.a, .minor, 0),      // A minor
            (.e, .minor, 1),      // E minor (1#)
            (.b, .minor, 2),      // B minor (2#)
            (.fSharp, .minor, 3), // F# minor (3#)
            (.cSharp, .minor, 4), // C# minor (4#)
            (.gSharp, .minor, 5), // G# minor (5#)
            (.dSharp, .minor, 6), // D# minor (6#)
            (.d, .minor, -1),     // D minor (1b)
            (.g, .minor, -2),     // G minor (2b)
            (.c, .minor, -3),     // C minor (3b)
            (.f, .minor, -4),     // F minor (4b)
            (.bFlat, .minor, -5), // Bb minor (5b)
            (.eFlat, .minor, -6), // Eb minor (6b)
        ]
        
        for (keyTonic, keyMode, accidentals) in circleOfFifths {
            if keyTonic.semitoneValue == tonic.semitoneValue && keyMode == mode {
                return KeySignature(accidentals: accidentals)
            }
        }
        
        return KeySignature(accidentals: 0) // デフォルト
    }
    
    /// 相対調を取得
    public var relativeKey: Key {
        switch mode {
        case .major:
            // 長調の6度下（短3度下）が相対短調
            let relativeMinorTonic = tonic.transposed(by: -3)
            return Key(tonic: relativeMinorTonic, mode: .minor)
        case .minor:
            // 短調の短3度上が相対長調
            let relativeMajorTonic = tonic.transposed(by: 3)
            return Key(tonic: relativeMajorTonic, mode: .major)
        }
    }
    
    /// 平行調を取得
    public var parallelKey: Key {
        return Key(tonic: tonic, mode: mode == .major ? .minor : .major)
    }
    
    /// スケール上の指定された度数の音名を取得
    /// - Parameter degree: 度数（1-7）
    /// - Returns: 該当する音名
    public func note(for degree: Int) -> Note? {
        guard degree >= 1 && degree <= 7 else { return nil }
        return scale[degree - 1]
    }
    
    /// 指定された音名がこのキーのスケールに含まれるかどうか
    /// - Parameter note: チェックする音名
    /// - Returns: 含まれる場合はtrue
    public func contains(note: Note) -> Bool {
        return scale.contains { $0.semitoneValue == note.semitoneValue }
    }
    
    /// このキーのダイアトニックコード一覧
    /// 注意: このプロパティは循環参照を避けるため、Domain層のDiatonicChordServiceで実装される
    /// Domain層からアクセスする場合は、DiatonicChordService.generateDiatonicChords(for:)を使用してください
    
    /// 適切な異名同音を選択するヘルパーメソッド
    private func findAppropriateNote(for semitoneValue: Int, in existingNotes: [Note]) -> Note? {
        let candidates = Note.allCases.filter { $0.semitoneValue == semitoneValue }
        
        // 既存の音名と重複しない異名同音を選択
        for candidate in candidates {
            let baseName = String(candidate.name.first!)
            let hasConflict = existingNotes.contains { existing in
                String(existing.name.first!) == baseName
            }
            
            if !hasConflict {
                return candidate
            }
        }
        
        return candidates.first
    }
}
