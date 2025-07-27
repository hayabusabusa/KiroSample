import Foundation
import SharedModels

/// 音楽理論計算結果をキャッシュするサービス
/// パフォーマンス最適化のため、よく使用される計算結果をメモリにキャッシュします
public actor MusicTheoryCache {
    /// シングルトンインスタンス
    public static let shared = MusicTheoryCache()

    /// キー→ダイアトニックコードのキャッシュ
    private var diatonicChordCache: [String: [DiatonicChord]] = [:]
    /// コード→キー提案のキャッシュ
    private var keySuggestionCache: [String: [KeySuggestion]] = [:]
    /// キャッシュサイズの上限
    private let maxCacheSize: Int = 100
    /// アクセス順序を追跡するためのキュー(LRU実装用)
    private var diatonicAccessOrder: [String] = []
    private var suggestionAccessOrder: [String] = []
    
    private init() {}
    
    // MARK: ダイアトニックコードキャッシュ
    
    /// キーのダイアトニックコードをキャッシュから取得
    /// - Parameter key: 対象のキー
    /// - Returns: キャッシュされたダイアトニックコードの配列（キャッシュミスの場合は空配列）
    public func getDiatonicChords(for key: Key) -> [DiatonicChord] {
        let cacheKey = key.cacheKey
        
        // キャッシュヒットの確認
        if let cachedChords = diatonicChordCache[cacheKey] {
            // LRU: アクセス順序を更新
            updateAccessOrder(key: cacheKey, in: &diatonicAccessOrder)
            return cachedChords
        }
        
        // キャッシュミス: 空配列を返す
        return []
    }
    
    /// ダイアトニックコードをキャッシュに保存
    /// - Parameters:
    ///   - chords: 保存するダイアトニックコード配列
    ///   - key: 対象のキー
    public func cacheDiatonicChords(_ chords: [DiatonicChord], for key: Key) {
        let cacheKey = key.cacheKey
        storeDiatonicChords(chords, for: cacheKey)
    }
    
    // MARK: キー提案キャッシュ
    
    /// コードのキー提案をキャッシュから取得
    /// - Parameter chord: 対象のコード
    /// - Returns: キャッシュされたキー提案の配列（キャッシュミスの場合は空配列）
    public func getKeySuggestions(for chord: Chord) -> [KeySuggestion] {
        let cacheKey = chord.cacheKey
        
        // キャッシュヒットの確認
        if let cachedSuggestions = keySuggestionCache[cacheKey] {
            // LRU: アクセス順序を更新
            updateAccessOrder(key: cacheKey, in: &suggestionAccessOrder)
            return cachedSuggestions
        }
        
        // キャッシュミス: 空配列を返す
        return []
    }
    
    /// キー提案をキャッシュに保存
    /// - Parameters:
    ///   - suggestions: 保存するキー提案配列
    ///   - chord: 対象のコード
    public func cacheKeySuggestions(_ suggestions: [KeySuggestion], for chord: Chord) {
        let cacheKey = chord.cacheKey
        storeKeySuggestions(suggestions, for: cacheKey)
    }
    
    // MARK: キャッシュ管理
    
    /// 全キャッシュをクリア
    public func clearAllCaches() {
        diatonicChordCache.removeAll()
        keySuggestionCache.removeAll()
        diatonicAccessOrder.removeAll()
        suggestionAccessOrder.removeAll()
    }
    
    /// ダイアトニックコードキャッシュをクリア
    public func clearDiatonicChordCache() {
        diatonicChordCache.removeAll()
        diatonicAccessOrder.removeAll()
    }
    
    /// キー提案キャッシュをクリア
    public func clearKeySuggestionCache() {
        keySuggestionCache.removeAll()
        suggestionAccessOrder.removeAll()
    }

    /// 現在のキャッシュ統計を取得
    public func getCacheStats() -> CacheStats {
        return CacheStats(
            diatonicCacheSize: diatonicChordCache.count,
            suggestionCacheSize: keySuggestionCache.count,
            maxCacheSize: maxCacheSize
        )
    }
}

// MARK: - Private

private extension MusicTheoryCache {
    /// キー提案をキャッシュに保存
    func storeKeySuggestions(_ suggestions: [KeySuggestion], for cacheKey: String) {
        // キャッシュサイズ制限の確認
        if keySuggestionCache.count >= maxCacheSize {
            // LRU: 最も古いエントリを削除
            if let oldestKey = suggestionAccessOrder.first {
                keySuggestionCache.removeValue(forKey: oldestKey)
                suggestionAccessOrder.removeFirst()
            }
        }

        keySuggestionCache[cacheKey] = suggestions
        suggestionAccessOrder.append(cacheKey)
    }

    /// ダイアトニックコードをキャッシュに保存
    func storeDiatonicChords(_ chords: [DiatonicChord], for cacheKey: String) {
        // キャッシュサイズ制限の確認
        if diatonicChordCache.count >= maxCacheSize {
            // LRU: 最も古いエントリを削除
            if let oldestKey = diatonicAccessOrder.first {
                diatonicChordCache.removeValue(forKey: oldestKey)
                diatonicAccessOrder.removeFirst()
            }
        }

        diatonicChordCache[cacheKey] = chords
        diatonicAccessOrder.append(cacheKey)
    }

    // MARK: LRUヘルパーメソッド

    /// アクセス順序を更新 (LRU実装)
    func updateAccessOrder(key: String, in accessOrder: inout [String]) {
        if let index = accessOrder.firstIndex(of: key) {
            accessOrder.remove(at: index)
        }
        accessOrder.append(key)
    }
}
// MARK: - キャッシュ統計

public extension MusicTheoryCache {
    /// キャッシュ統計情報
    struct CacheStats: Sendable {
        public let diatonicCacheSize: Int
        public let suggestionCacheSize: Int
        public let maxCacheSize: Int

        public var diatonicCacheUsage: Double {
            return Double(diatonicCacheSize) / Double(maxCacheSize)
        }

        public var suggestionCacheUsage: Double {
            return Double(suggestionCacheSize) / Double(maxCacheSize)
        }
    }
}

// MARK: - キャッシュキー生成用拡張

public extension Key {
    /// キャッシュキー生成用のプロパティ
    var cacheKey: String {
        return "\(tonic.rawValue)_\(mode.rawValue)"
    }
}

public extension Chord {
    /// キャッシュキー生成用のプロパティ
    var cacheKey: String {
        let bassString = bass?.rawValue ?? "none"
        let extensionString = extensions.map { ext in
            switch ext {
            case .ninth: return "9"
            case .eleventh: return "11"
            case .thirteenth: return "13"
            case .flatFive: return "b5"
            case .sharpFive: return "#5"
            case .flatNine: return "b9"
            case .sharpNine: return "#9"
            case .sharpEleven: return "#11"
            case .flatThirteen: return "b13"
            }
        }.joined(separator: "_")
        return "\(root.rawValue)_\(quality.symbol)_\(extensionString)_\(bassString)"
    }
}
