//
//  Chord.swift
//  SharedModels
//
//  Created by Claude on 2025/07/21.
//

import Foundation

/// コードを表す構造体
public struct Chord: Equatable, Hashable, Sendable {
    /// ルート音
    public let root: Note
    
    /// コードの品質
    public let quality: ChordQuality
    
    /// 拡張要素
    public let extensions: [ChordExtension]
    
    /// ベース音（スラッシュコードの場合）
    public let bass: Note?
    
    /// イニシャライザ
    /// - Parameters:
    ///   - root: ルート音
    ///   - quality: コードの品質
    ///   - extensions: 拡張要素の配列
    ///   - bass: ベース音（オプション）
    public init(root: Note, quality: ChordQuality, extensions: [ChordExtension] = [], bass: Note? = nil) {
        self.root = root
        self.quality = quality
        self.extensions = extensions
        self.bass = bass
    }
    
    /// コードの記号表現
    public var symbol: String {
        var result = root.name
        result += quality.symbol
        
        // 拡張要素を追加
        for ext in extensions.sorted(by: { $0.symbol < $1.symbol }) {
            result += ext.symbol
        }
        
        // ベース音を追加（スラッシュコード）
        if let bass = bass, bass != root {
            result += "/\(bass.name)"
        }
        
        return result
    }
    
    /// このコードに含まれる音名を取得
    public var notes: [Note] {
        var notes: [Note] = []
        
        // 基本的な音程を追加
        for interval in quality.intervals {
            let noteIndex = (root.semitoneValue + interval) % 12
            if let note = Note.allCases.first(where: { $0.semitoneValue == noteIndex }) {
                notes.append(note)
            }
        }
        
        // 拡張要素による音程を追加
        for ext in extensions {
            let interval: Int
            switch ext {
            case .ninth: interval = 14 // Major 9th
            case .eleventh: interval = 17 // Perfect 11th
            case .thirteenth: interval = 21 // Major 13th
            case .flatFive: interval = 6 // Diminished 5th
            case .sharpFive: interval = 8 // Augmented 5th
            case .flatNine: interval = 13 // Minor 9th
            case .sharpNine: interval = 15 // Augmented 9th
            case .sharpEleven: interval = 18 // Augmented 11th
            case .flatThirteen: interval = 20 // Minor 13th
            }
            
            let noteIndex = (root.semitoneValue + interval) % 12
            if let note = Note.allCases.first(where: { $0.semitoneValue == noteIndex }) {
                if !notes.contains(note) {
                    notes.append(note)
                }
            }
        }
        
        return notes
    }
    
    /// このコードがトライアド（三和音）かどうか
    public var isTriad: Bool {
        return !quality.isSeventh && !quality.isExtended && extensions.isEmpty
    }
    
    /// このコードが7thコードかどうか
    public var isSeventhChord: Bool {
        return quality.isSeventh || extensions.contains { ext in
            switch ext {
            case .ninth, .eleventh, .thirteenth:
                return true
            default:
                return false
            }
        }
    }
    
    /// このコードがスラッシュコードかどうか
    public var isSlashChord: Bool {
        return bass != nil && bass != root
    }
    
    /// 指定された音名がこのコードに含まれるかどうか
    /// - Parameter note: チェックする音名
    /// - Returns: 含まれる場合はtrue
    public func contains(note: Note) -> Bool {
        return notes.contains { $0.semitoneValue == note.semitoneValue }
    }
    
    /// コードを転回する
    /// - Parameter inversion: 転回数（0=基本形、1=第1転回形、2=第2転回形...）
    /// - Returns: 転回されたコード
    public func inverted(by inversion: Int) -> Chord {
        let chordNotes = notes
        guard inversion > 0 && inversion < chordNotes.count else {
            return self
        }
        
        let bassNote = chordNotes[inversion]
        return Chord(root: root, quality: quality, extensions: extensions, bass: bassNote)
    }
}