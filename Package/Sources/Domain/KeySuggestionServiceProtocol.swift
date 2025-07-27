import Foundation
import SharedModels

/// キーサジェスト機能を提供するサービスのプロトコル
public protocol KeySuggestionServiceProtocol: Sendable {
    /// 指定されたコードを含む可能性のあるキーを提案する
    /// - Parameter chord: 分析対象のコード
    /// - Returns: 信頼度の高い順にソートされたキー提案の配列
    func suggestKeys(for chord: Chord) async -> [KeySuggestion]
    
    /// 直接計算でキー提案を生成する（キャッシュをバイパス）
    /// - Parameter chord: 分析対象のコード
    /// - Returns: 信頼度の高い順にソートされたキー提案の配列
    func suggestKeysDirectly(for chord: Chord) -> [KeySuggestion]
}