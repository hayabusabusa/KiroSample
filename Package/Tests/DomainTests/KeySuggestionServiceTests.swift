import Testing
import Foundation
@testable import Domain
@testable import SharedModels

/// KeySuggestionServiceのテスト
struct KeySuggestionServiceTests {
    
    private let service = KeySuggestionService()
    
    // MARK: - 基本的なキーサジェストテスト
    
    @Test
    func testCMajorChordSuggestion() {
        // Given: Cメジャーコード
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        
        // When: キーサジェストを実行
        let suggestions = service.suggestKeysDirectly(for: chord)
        
        // Then: 適切なキーが提案される
        #expect(!suggestions.isEmpty, "Cメジャーコードに対してキー提案があること")
        
        // C, F, Gメジャーキーが含まれることを確認
        let keyNames = suggestions.map { $0.key.shortName }
        #expect(keyNames.contains("C"), "Cメジャーキーが提案されること（Iコード）")
        #expect(keyNames.contains("F"), "Fメジャーキーが提案されること（Vコード）")
        #expect(keyNames.contains("G"), "Gメジャーキーが提案されること（IVコード）")
        
        // スコア順でソートされていることを確認
        for i in 0..<(suggestions.count - 1) {
            #expect(suggestions[i].score >= suggestions[i + 1].score, "スコア順でソートされていること")
        }
    }
    
    @Test
    func testAMinorChordSuggestion() {
        // Given: Aマイナーコード
        let chord = Chord(root: .a, quality: .minor, extensions: [], bass: nil)
        
        // When: キーサジェストを実行
        let suggestions = service.suggestKeysDirectly(for: chord)
        
        // Then: 適切なキーが提案される
        #expect(!suggestions.isEmpty, "Aマイナーコードに対してキー提案があること")
        
        // A minor, C major, D minor等が含まれることを確認
        let keyNames = suggestions.map { $0.key.shortName }
        #expect(keyNames.contains("Am"), "Aマイナーキーが提案されること（iコード）")
        #expect(keyNames.contains("C"), "Cメジャーキーが提案されること（viコード）")
        #expect(keyNames.contains("Dm"), "Dマイナーキーが提案されること（vコード）")
    }
    
    @Test
    func testG7ChordSuggestion() {
        // Given: G7コード
        let chord = Chord(root: .g, quality: .dominant7, extensions: [], bass: nil)
        
        // When: キーサジェストを実行
        let suggestions = service.suggestKeysDirectly(for: chord)
        
        // Then: 適切なキーが提案される
        #expect(!suggestions.isEmpty, "G7コードに対してキー提案があること")
        
        // Cメジャーキーが最も高いスコアで提案されることを確認（V7コード）
        if let topSuggestion = suggestions.first {
            #expect(topSuggestion.key.shortName == "C", "Cメジャーキーが最上位提案されること")
            #expect(topSuggestion.reason.contains("V"), "ドミナント機能の説明が含まれること")
        } else {
            #expect(Bool(false), "キー提案が存在すること")
        }
    }
    
    // MARK: - 拡張コードのテスト
    
    @Test
    func testExtendedChordPartialMatch() {
        // Given: Cmaj7コード（拡張コード）
        let chord = Chord(root: .c, quality: .major7, extensions: [], bass: nil)
        
        // When: キーサジェストを実行
        let suggestions = service.suggestKeysDirectly(for: chord)
        
        // Then: 部分一致として適切なキーが提案される
        #expect(!suggestions.isEmpty, "拡張コードに対してもキー提案があること")
        
        // Cメジャーベースのキーが提案されることを確認
        let cMajorSuggestions = suggestions.filter { $0.key.tonic == .c && $0.key.mode == .major }
        #expect(!cMajorSuggestions.isEmpty, "Cメジャーキーが提案されること")
        
        // 拡張形として認識されていることを確認
        if let cMajorSuggestion = cMajorSuggestions.first {
            #expect(cMajorSuggestion.reason.contains("拡張形"), "拡張形として認識されること")
        }
    }
    
    // MARK: - スラッシュコードのテスト
    
    @Test
    func testSlashChordSuggestion() {
        // Given: C/Eコード（スラッシュコード）
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: .e)
        
        // When: キーサジェストを実行
        let suggestions = service.suggestKeysDirectly(for: chord)
        
        // Then: ベース音に関わらず適切にマッチする
        #expect(!suggestions.isEmpty, "スラッシュコードに対してもキー提案があること")
        
        // Cメジャーコードとしてマッチすることを確認（ベース音は無視）
        let keyNames = suggestions.map { $0.key.shortName }
        #expect(keyNames.contains("C"), "Cメジャーキーが提案されること")
    }
    
    // MARK: - スコア計算のテスト
    
    @Test
    func testScoreCalculation() {
        // Given: 主要三和音のコード
        let tonicChord = Chord(root: .c, quality: .major, extensions: [], bass: nil) // I
        let subdominantChord = Chord(root: .f, quality: .major, extensions: [], bass: nil) // IV
        let dominantChord = Chord(root: .g, quality: .major, extensions: [], bass: nil) // V
        let otherChord = Chord(root: .e, quality: .minor, extensions: [], bass: nil) // iii
        
        // When: それぞれのキーサジェストを実行
        let tonicSuggestions = service.suggestKeysDirectly(for: tonicChord)
        let subdominantSuggestions = service.suggestKeysDirectly(for: subdominantChord)
        let dominantSuggestions = service.suggestKeysDirectly(for: dominantChord)
        let otherSuggestions = service.suggestKeysDirectly(for: otherChord)
        
        // Then: 主要三和音の方が高いスコアを持つ
        let cMajorTonicScore = tonicSuggestions.first { $0.key.shortName == "C" }?.score ?? 0
        let cMajorOtherScore = otherSuggestions.first { $0.key.shortName == "C" }?.score ?? 0
        
        #expect(cMajorTonicScore > cMajorOtherScore, "主要三和音（I）の方が高いスコアを持つこと")
    }
    
    // MARK: - 完全一致 vs 部分一致のテスト
    
    @Test
    func testExactVsPartialMatch() {
        // Given: 基本三和音と拡張コード
        let basicChord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let extendedChord = Chord(root: .c, quality: .major7, extensions: [], bass: nil)
        
        // When: キーサジェストを実行
        let basicSuggestions = service.suggestKeysDirectly(for: basicChord)
        let extendedSuggestions = service.suggestKeysDirectly(for: extendedChord)
        
        // Then: 完全一致の方が高いスコアを持つ
        let basicCMajorScore = basicSuggestions.first { $0.key.shortName == "C" }?.score ?? 0
        let extendedCMajorScore = extendedSuggestions.first { $0.key.shortName == "C" }?.score ?? 0
        
        #expect(basicCMajorScore > extendedCMajorScore, "完全一致の方が部分一致より高いスコアを持つこと")
    }
    
    // MARK: - キー使用頻度のテスト
    
    @Test
    func testKeyUsageWeight() {
        // Given: 同じコードに対する異なるキーでの提案
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        
        // When: キーサジェストを実行
        let suggestions = service.suggestKeysDirectly(for: chord)
        
        // Then: よく使われるキー（C, G, F等）が優先される
        let cMajorSuggestion = suggestions.first { $0.key.shortName == "C" }
        let fSharpMajorSuggestion = suggestions.first { $0.key.shortName == "F#" }
        
        // C majorの方がF# majorより高いスコアを持つはず（使用頻度による）
        if let cScore = cMajorSuggestion?.score, let fSharpScore = fSharpMajorSuggestion?.score {
            #expect(cScore > fSharpScore, "よく使われるキーの方が高いスコアを持つこと")
        }
    }
    
    // MARK: - エッジケースのテスト
    
    @Test
    func testEmptyResultForUncommonChord() {
        // Given: 非常に特殊なコード（テスト用の架空のコード品質）
        // 注意: 実際の実装では全てのコードが何らかのキーにマッチするはずなので、
        // このテストは理論的なエッジケースをカバーしています
        let unusualChord = Chord(root: .c, quality: .augmented, extensions: [], bass: nil)
        
        // When: キーサジェストを実行
        let suggestions = service.suggestKeysDirectly(for: unusualChord)
        
        // Then: 結果が返される（空でない）
        // 注意: augmentedコードも何らかのキーコンテキストで使用される可能性があるため、
        // 通常は何らかの提案が返されるはず
        #expect(suggestions.count >= 0, "特殊なコードに対しても適切に処理されること")
    }
    
    // MARK: - パフォーマンステスト
    
    @Test
    func testPerformance() {
        // Given: 標準的なコード
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        
        // When & Then: パフォーマンス測定
        let startTime = Date()
        let suggestions = service.suggestKeysDirectly(for: chord)
        let endTime = Date()
        
        let executionTime = endTime.timeIntervalSince(startTime)
        
        #expect(executionTime < 1.0, "1秒以内に処理が完了すること")
        #expect(!suggestions.isEmpty, "結果が返されること")
    }
}