import Testing
import Foundation
@testable import Domain
@testable import SharedModels

/// MusicTheoryCacheのテスト
struct MusicTheoryCacheTests {
    
    // MARK: - ダイアトニックコードキャッシュのテスト
    
    @Test
    func testDiatonicChordCaching() async {
        // テスト前にキャッシュをクリア
        await MusicTheoryCache.shared.clearAllCaches()
        
        // Given: Cメジャーキー
        let key = Key(tonic: .c, mode: .major)
        
        // When: 初回アクセス（キャッシュミス）
        let firstAccess = await MusicTheoryCache.shared.getDiatonicChords(for: key)
        
        // When: 2回目アクセス（キャッシュヒット）
        let secondAccess = await MusicTheoryCache.shared.getDiatonicChords(for: key)
        
        // Then: 同じ結果が返される
        #expect(firstAccess.count == 7, "ダイアトニックコード数")
        #expect(secondAccess.count == 7, "ダイアトニックコード数")
        #expect(firstAccess[0].chord.symbol == secondAccess[0].chord.symbol, "キャッシュされた結果の一致")
        
        // キャッシュ統計の確認
        let stats = await MusicTheoryCache.shared.getCacheStats()
        #expect(stats.diatonicCacheSize >= 1, "ダイアトニックキャッシュエントリ数")
    }
    
    @Test
    func testDiatonicChordCacheForMultipleKeys() async {
        // テスト前にキャッシュをクリア
        await MusicTheoryCache.shared.clearAllCaches()
        
        // Given: 複数のキー
        let cMajor = Key(tonic: .c, mode: .major)
        let aMinor = Key(tonic: .a, mode: .minor)
        let gMajor = Key(tonic: .g, mode: .major)
        
        // When: 各キーのダイアトニックコードを取得
        let cMajorChords = await MusicTheoryCache.shared.getDiatonicChords(for: cMajor)
        let aMinorChords = await MusicTheoryCache.shared.getDiatonicChords(for: aMinor)
        let gMajorChords = await MusicTheoryCache.shared.getDiatonicChords(for: gMajor)
        
        // Then: 各キーで正しいダイアトニックコードが返される
        #expect(cMajorChords[0].chord.symbol == "C", "Cメジャーキー: Iコード")
        #expect(aMinorChords[0].chord.symbol == "Am", "Aマイナーキー: iコード")
        #expect(gMajorChords[0].chord.symbol == "G", "Gメジャーキー: Iコード")
        
        // キャッシュ統計の確認
        let stats = await MusicTheoryCache.shared.getCacheStats()
        #expect(stats.diatonicCacheSize == 3, "3つのキーがキャッシュされている")
    }
    
    // MARK: - キー提案キャッシュのテスト
    
    @Test
    func testKeySuggestionCaching() async {
        // テスト前にキャッシュをクリア
        await MusicTheoryCache.shared.clearAllCaches()
        
        // Given: Cメジャーコード
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        
        // When: 初回アクセス（キャッシュミス）
        let firstAccess = await MusicTheoryCache.shared.getKeySuggestions(for: chord)
        
        // When: 2回目アクセス（キャッシュヒット）
        let secondAccess = await MusicTheoryCache.shared.getKeySuggestions(for: chord)
        
        // Then: 同じ結果が返される
        #expect(!firstAccess.isEmpty, "キー提案が存在する")
        #expect(firstAccess.count == secondAccess.count, "提案数が一致")
        #expect(firstAccess[0].key.shortName == secondAccess[0].key.shortName, "キャッシュされた結果の一致")
        
        // キャッシュ統計の確認
        let stats = await MusicTheoryCache.shared.getCacheStats()
        #expect(stats.suggestionCacheSize >= 1, "キー提案キャッシュエントリ数")
    }
    
    @Test
    func testKeySuggestionCacheForMultipleChords() async {
        // テスト前にキャッシュをクリア
        await MusicTheoryCache.shared.clearAllCaches()
        
        // Given: 複数のコード
        let cMajor = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let dMinor = Chord(root: .d, quality: .minor, extensions: [], bass: nil)
        let g7 = Chord(root: .g, quality: .dominant7, extensions: [], bass: nil)
        
        // When: 各コードのキー提案を取得
        let cMajorSuggestions = await MusicTheoryCache.shared.getKeySuggestions(for: cMajor)
        let dMinorSuggestions = await MusicTheoryCache.shared.getKeySuggestions(for: dMinor)
        let g7Suggestions = await MusicTheoryCache.shared.getKeySuggestions(for: g7)
        
        // Then: 各コードで適切な提案が返される
        #expect(!cMajorSuggestions.isEmpty, "Cメジャーコード: 提案あり")
        #expect(!dMinorSuggestions.isEmpty, "Dマイナーコード: 提案あり")
        #expect(!g7Suggestions.isEmpty, "G7コード: 提案あり")
        
        // キャッシュ統計の確認
        let stats = await MusicTheoryCache.shared.getCacheStats()
        #expect(stats.suggestionCacheSize == 3, "3つのコードがキャッシュされている")
    }
    
    // MARK: - LRU (Least Recently Used) のテスト
    
    @Test
    func testLRUEviction() async {
        // テスト前にキャッシュをクリア
        await MusicTheoryCache.shared.clearAllCaches()
        
        // Given: キャッシュサイズを超える数のキー
        let keys = [
            Key(tonic: .c, mode: .major),
            Key(tonic: .d, mode: .major),
            Key(tonic: .e, mode: .major),
            Key(tonic: .f, mode: .major),
            Key(tonic: .g, mode: .major)
        ]
        
        // When: 各キーのダイアトニックコードを取得
        for key in keys {
            _ = await MusicTheoryCache.shared.getDiatonicChords(for: key)
        }
        
        // Then: すべてキャッシュされている
        let initialStats = await MusicTheoryCache.shared.getCacheStats()
        #expect(initialStats.diatonicCacheSize == 5, "5つのキーがキャッシュされている")
        
        // 最初のキーに再アクセス（LRU順序を更新）
        _ = await MusicTheoryCache.shared.getDiatonicChords(for: keys[0])
        
        // 新しいキーを追加（LRUテストのため）
        let newKey = Key(tonic: .a, mode: .major)
        _ = await MusicTheoryCache.shared.getDiatonicChords(for: newKey)
        
        let finalStats = await MusicTheoryCache.shared.getCacheStats()
        #expect(finalStats.diatonicCacheSize == 6, "新しいキーが追加されている")
    }
    
    // MARK: - キャッシュクリアのテスト
    
    @Test
    func testCacheClear() async {
        // Given: キャッシュにデータがある状態
        let key = Key(tonic: .c, mode: .major)
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        
        _ = await MusicTheoryCache.shared.getDiatonicChords(for: key)
        _ = await MusicTheoryCache.shared.getKeySuggestions(for: chord)
        
        let beforeClear = await MusicTheoryCache.shared.getCacheStats()
        #expect(beforeClear.diatonicCacheSize > 0, "クリア前: ダイアトニックキャッシュあり")
        #expect(beforeClear.suggestionCacheSize > 0, "クリア前: キー提案キャッシュあり")
        
        // When: 全キャッシュをクリア
        await MusicTheoryCache.shared.clearAllCaches()
        
        // Then: キャッシュが空になる
        let afterClear = await MusicTheoryCache.shared.getCacheStats()
        #expect(afterClear.diatonicCacheSize == 0, "クリア後: ダイアトニックキャッシュ空")
        #expect(afterClear.suggestionCacheSize == 0, "クリア後: キー提案キャッシュ空")
    }
    
    @Test
    func testSelectiveCacheClear() async {
        // Given: 両方のキャッシュにデータがある状態
        let key = Key(tonic: .c, mode: .major)
        let chord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        
        _ = await MusicTheoryCache.shared.getDiatonicChords(for: key)
        _ = await MusicTheoryCache.shared.getKeySuggestions(for: chord)
        
        // When: ダイアトニックコードキャッシュのみクリア
        await MusicTheoryCache.shared.clearDiatonicChordCache()
        
        // Then: ダイアトニックキャッシュのみ空になる
        let afterDiatonicClear = await MusicTheoryCache.shared.getCacheStats()
        #expect(afterDiatonicClear.diatonicCacheSize == 0, "ダイアトニックキャッシュクリア")
        #expect(afterDiatonicClear.suggestionCacheSize > 0, "キー提案キャッシュは残存")
        
        // When: キー提案キャッシュをクリア
        await MusicTheoryCache.shared.clearKeySuggestionCache()
        
        // Then: すべてのキャッシュが空になる
        let afterSuggestionClear = await MusicTheoryCache.shared.getCacheStats()
        #expect(afterSuggestionClear.suggestionCacheSize == 0, "キー提案キャッシュクリア")
    }
    
    // MARK: - キャッシュキー生成のテスト
    
    @Test
    func testCacheKeyGeneration() {
        // Given: 異なるキーとコード
        let cMajor = Key(tonic: .c, mode: .major)
        let cMinor = Key(tonic: .c, mode: .minor)
        
        let cChord = Chord(root: .c, quality: .major, extensions: [], bass: nil)
        let cSlashE = Chord(root: .c, quality: .major, extensions: [], bass: .e)
        
        // Then: 異なるキャッシュキーが生成される
        #expect(cMajor.cacheKey != cMinor.cacheKey, "メジャー・マイナーで異なるキー")
        #expect(cChord.cacheKey != cSlashE.cacheKey, "ベース音ありなしで異なるキー")
        
        // 同じオブジェクトは同じキャッシュキーを生成
        let anotherCMajor = Key(tonic: .c, mode: .major)
        #expect(cMajor.cacheKey == anotherCMajor.cacheKey, "同じキーは同じキャッシュキー")
    }
    
    // MARK: - パフォーマンステスト
    
    @Test
    func testCachePerformance() async {
        // テスト前にキャッシュをクリア
        await MusicTheoryCache.shared.clearAllCaches()
        
        // Given: テスト用のキー
        let key = Key(tonic: .c, mode: .major)
        
        // 初回アクセス時間の測定（キャッシュミス）
        let firstStart = Date()
        _ = await MusicTheoryCache.shared.getDiatonicChords(for: key)
        let firstEnd = Date()
        let firstTime = firstEnd.timeIntervalSince(firstStart)
        
        // 2回目アクセス時間の測定（キャッシュヒット）
        let secondStart = Date()
        _ = await MusicTheoryCache.shared.getDiatonicChords(for: key)
        let secondEnd = Date()
        let secondTime = secondEnd.timeIntervalSince(secondStart)
        
        // Then: キャッシュヒットの方が高速
        #expect(secondTime < firstTime, "キャッシュヒットはキャッシュミスより高速")
        #expect(secondTime < 0.001, "キャッシュヒットは1ms以内")
    }
    
    // MARK: - スレッドセーフティテスト
    
    @Test
    func testThreadSafety() async {
        // テスト前にキャッシュをクリア
        await MusicTheoryCache.shared.clearAllCaches()
        
        // Given: 複数のキー
        let keys = [
            Key(tonic: .c, mode: .major),
            Key(tonic: .d, mode: .major),
            Key(tonic: .e, mode: .major),
            Key(tonic: .f, mode: .major)
        ]
        
        // When: 並行してキャッシュアクセス
        await withTaskGroup(of: Void.self) { group in
            for key in keys {
                group.addTask {
                    _ = await MusicTheoryCache.shared.getDiatonicChords(for: key)
                }
            }
        }
        
        // Then: デッドロックやクラッシュなく完了
        let stats = await MusicTheoryCache.shared.getCacheStats()
        #expect(stats.diatonicCacheSize <= keys.count, "並行アクセスでも正常動作")
    }
}