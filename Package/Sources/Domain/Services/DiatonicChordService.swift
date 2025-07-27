import Foundation
import SharedModels

/// ダイアトニックコード生成サービス
public final class DiatonicChordService: DiatonicChordServiceProtocol {
    
    public init() {}
    
    /// 指定されたキーのダイアトニックコード一覧を生成する（キャッシュ統合版）
    /// - Parameter key: ダイアトニックコードを生成するキー
    /// - Returns: ダイアトニックコードの配列（I, ii, iii, IV, V, vi, vii°の順）
    public func generateDiatonicChords(for key: Key) async -> [DiatonicChord] {
        // キャッシュから取得を試行
        let cachedChords = await MusicTheoryCache.shared.getDiatonicChords(for: key)
        if !cachedChords.isEmpty {
            return cachedChords
        }
        
        // キャッシュミス: 新規計算
        let chords = generateDiatonicChordsDirectly(for: key)
        
        // キャッシュに保存
        await MusicTheoryCache.shared.cacheDiatonicChords(chords, for: key)
        
        return chords
    }
    
    /// 直接計算でダイアトニックコードを生成する（キャッシュをバイパス）
    /// - Parameter key: ダイアトニックコードを生成するキー
    /// - Returns: ダイアトニックコードの配列
    public func generateDiatonicChordsDirectly(for key: Key) -> [DiatonicChord] {
        let scale = generateScale(for: key)
        var diatonicChords: [DiatonicChord] = []
        
        for (index, degree) in ScaleDegree.allCases.enumerated() {
            let chord = buildTriad(fromScale: scale, degree: index)
            let function = harmonicFunction(for: degree, in: key.mode)
            let romanNumeral = romanNumeralForDegree(degree, in: key.mode, chord: chord)
            
            diatonicChords.append(DiatonicChord(
                degree: degree,
                chord: chord,
                function: function,
                romanNumeral: romanNumeral
            ))
        }
        
        return diatonicChords
    }
    
    // MARK: - Private Helper Methods
    
    /// キーに対応するスケールを生成する
    private func generateScale(for key: Key) -> [Note] {
        let intervals: [Int]
        
        switch key.mode {
        case .major:
            intervals = [0, 2, 4, 5, 7, 9, 11]  // メジャースケール
        case .minor:
            intervals = [0, 2, 3, 5, 7, 8, 10]  // ナチュラルマイナースケール
        }
        
        return intervals.map { interval in
            let semitone = (key.tonic.semitoneValue + interval) % 12
            return Note.allCases.first { $0.semitoneValue == semitone }!
        }
    }
    
    /// スケールから三和音を構築する
    private func buildTriad(fromScale scale: [Note], degree: Int) -> Chord {
        let root = scale[degree]
        let third = scale[(degree + 2) % 7]
        let fifth = scale[(degree + 4) % 7]
        
        let quality = determineChordQuality(root: root, third: third, fifth: fifth)
        
        return Chord(root: root, quality: quality, extensions: [], bass: nil)
    }
    
    /// ルート、3度、5度の音から和音の種類を判定する
    private func determineChordQuality(root: Note, third: Note, fifth: Note) -> ChordQuality {
        let thirdInterval = (third.semitoneValue - root.semitoneValue + 12) % 12
        let fifthInterval = (fifth.semitoneValue - root.semitoneValue + 12) % 12
        
        switch (thirdInterval, fifthInterval) {
        case (4, 7):
            return .major      // 長三度 + 完全五度
        case (3, 7):
            return .minor      // 短三度 + 完全五度
        case (3, 6):
            return .diminished // 短三度 + 減五度
        case (4, 8):
            return .augmented  // 長三度 + 増五度
        default:
            return .major      // デフォルトはメジャー
        }
    }
    
    /// スケール度数とモードに基づいてハーモニック機能を判定する
    private func harmonicFunction(for degree: ScaleDegree, in mode: KeyMode) -> HarmonicFunction {
        switch (degree, mode) {
        case (.i, _), (.iii, .major), (.vi, .major):
            return .tonic
        case (.ii, _), (.iv, _):
            return .subdominant
        case (.v, _), (.vii, _):
            return .dominant
        default:
            return .tonic  // デフォルト
        }
    }
    
    /// スケール度数、モード、コード品質に基づいてローマ数字表記を生成する
    private func romanNumeralForDegree(_ degree: ScaleDegree, in mode: KeyMode, chord: Chord) -> String {
        let baseNumeral: String
        
        switch degree {
        case .i: baseNumeral = "I"
        case .ii: baseNumeral = "ii"
        case .iii: baseNumeral = "iii"
        case .iv: baseNumeral = "IV"
        case .v: baseNumeral = "V"
        case .vi: baseNumeral = "vi"
        case .vii: baseNumeral = "vii"
        }
        
        // コード品質に応じて大文字・小文字を調整
        var romanNumeral = baseNumeral
        
        switch chord.quality {
        case .major:
            romanNumeral = baseNumeral.uppercased()
        case .minor:
            romanNumeral = baseNumeral.lowercased()
        case .diminished:
            romanNumeral = baseNumeral.lowercased() + "°"
        case .augmented:
            romanNumeral = baseNumeral.uppercased() + "+"
        default:
            romanNumeral = baseNumeral
        }
        
        return romanNumeral
    }
}