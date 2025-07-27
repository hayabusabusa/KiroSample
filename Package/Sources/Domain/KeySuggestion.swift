import Foundation
import SharedModels

/// キー提案結果を表すデータ構造
public struct KeySuggestion: Sendable, Equatable, Hashable {
    /// 提案されるキー
    public let key: Key
    /// なぜこのキーが提案されるかの理由
    public let reason: String
    /// 提案の信頼度スコア（高いほど適切）
    public let score: Double
    
    public init(key: Key, reason: String, score: Double) {
        self.key = key
        self.reason = reason
        self.score = score
    }
}

/// コード一致の種類
public enum MatchType: Sendable {
    /// 完全一致（コードが完全に同じ）
    case exact
    /// 部分一致（基本三和音は同じだが拡張音が異なる）
    case partial
}