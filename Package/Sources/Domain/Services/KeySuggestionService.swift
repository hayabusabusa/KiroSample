import Foundation
import SharedModels

/// キーサジェスト機能を提供するサービス
public final class KeySuggestionService: KeySuggestionServiceProtocol {
    
    private let diatonicChordService: DiatonicChordServiceProtocol
    
    public init(diatonicChordService: DiatonicChordServiceProtocol = DiatonicChordService()) {
        self.diatonicChordService = diatonicChordService
    }
    
    /// 指定されたコードを含む可能性のあるキーを提案する（キャッシュ統合版）
    /// - Parameter chord: 分析対象のコード
    /// - Returns: 信頼度の高い順にソートされたキー提案の配列
    public func suggestKeys(for chord: Chord) async -> [KeySuggestion] {
        // キャッシュから取得を試行
        let cachedSuggestions = await MusicTheoryCache.shared.getKeySuggestions(for: chord)
        if !cachedSuggestions.isEmpty {
            return cachedSuggestions
        }
        
        // キャッシュミス: 新規計算
        let suggestions = suggestKeysDirectly(for: chord)
        
        // キャッシュに保存
        await MusicTheoryCache.shared.cacheKeySuggestions(suggestions, for: chord)
        
        return suggestions
    }
    
    /// 直接計算でキー提案を生成する（キャッシュをバイパス）
    /// - Parameter chord: 分析対象のコード
    /// - Returns: 信頼度の高い順にソートされたキー提案の配列
    public func suggestKeysDirectly(for chord: Chord) -> [KeySuggestion] {
        var suggestions: [KeySuggestion] = []
        
        // 全キーに対してチェック
        for tonic in Note.allCases {
            for mode in [KeyMode.major, KeyMode.minor] {
                let key = Key(tonic: tonic, mode: mode)
                
                if let suggestion = checkChordInKey(chord: chord, key: key) {
                    suggestions.append(suggestion)
                }
            }
        }
        
        // 理論的重要度とよく使われる度合いでソート
        return suggestions.sorted { $0.score > $1.score }
    }
    
    // MARK: - Private Helper Methods
    
    /// 指定されたコードが特定のキーに含まれるかチェックする
    private func checkChordInKey(chord: Chord, key: Key) -> KeySuggestion? {
        let diatonicChords = diatonicChordService.generateDiatonicChordsDirectly(for: key)
        
        // 完全一致チェック
        if let matchedChord = diatonicChords.first(where: { $0.chord == chord }) {
            return KeySuggestion(
                key: key,
                reason: "\(matchedChord.romanNumeral)コードとして含まれます",
                score: calculateScore(for: key, chordDegree: matchedChord.degree, matchType: .exact)
            )
        }
        
        // 部分一致チェック（基本三和音ベース）
        let baseQuality = getBaseTriadQuality(from: chord.quality)
        let simpleChord = Chord(root: chord.root, quality: baseQuality, extensions: [], bass: nil)
        if let matchedChord = diatonicChords.first(where: { 
            $0.chord.root == simpleChord.root && $0.chord.quality == simpleChord.quality 
        }) {
            return KeySuggestion(
                key: key,
                reason: "\(matchedChord.romanNumeral)コード（\(chord.symbol)は拡張形）として含まれます",
                score: calculateScore(for: key, chordDegree: matchedChord.degree, matchType: .partial)
            )
        }
        
        return nil
    }
    
    /// キー提案のスコアを計算する
    private func calculateScore(for key: Key, chordDegree: ScaleDegree, matchType: MatchType) -> Double {
        var score: Double = 0
        
        // 基本スコア
        score += matchType == .exact ? 10 : 7
        
        // コード機能による重み付け
        switch chordDegree {
        case .i, .iv, .v: score += 3  // 主要三和音
        case .ii, .vi: score += 2     // 準主要三和音
        case .iii, .vii: score += 1   // その他
        }
        
        // キーの使用頻度による重み付け
        score += keyUsageWeight(for: key)
        
        return score
    }
    
    /// キーの使用頻度に基づく重み付けを計算する
    private func keyUsageWeight(for key: Key) -> Double {
        // よく使われるキーに高いスコアを付与
        switch key.tonic {
        case .c, .g, .d, .a, .e:
            return key.mode == .major ? 2.0 : 1.5  // メジャーキーをやや優遇
        case .f, .b, .fSharp, .cSharp:
            return key.mode == .major ? 1.5 : 1.0
        default:
            return 1.0
        }
    }
    
    /// 7thコードや拡張コードから基本三和音の品質を取得する
    private func getBaseTriadQuality(from quality: ChordQuality) -> ChordQuality {
        switch quality {
        case .major, .major7, .major9, .major11, .major13, .add9:
            return .major
        case .minor, .minor7, .minor9, .minor11, .minor13, .minorMajor7:
            return .minor
        case .dominant7, .dominant9, .dominant11, .dominant13:
            return .major  // ドミナント7thは基本的にメジャートライアド + b7
        case .diminished, .diminished7, .halfDiminished7:
            return .diminished
        case .augmented, .augmented7:
            return .augmented
        case .sus2, .sus4:
            return quality  // sus系はそのまま
        }
    }
}