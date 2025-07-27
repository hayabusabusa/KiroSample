import Foundation
import SharedModels

/// コードパーサーのプロトコル
public protocol ChordParserProtocol: Sendable {
    /// コード文字列を解析してChordオブジェクトを生成する
    /// - Parameter input: 解析するコード文字列（例: "C", "Am7", "F#dim"）
    /// - Returns: 解析されたChordオブジェクト
    /// - Throws: ChordParsingError
    func parse(_ input: String) throws -> Chord
    
    /// コード文字列の基本的なバリデーションを行う
    /// - Parameter input: 検証するコード文字列
    /// - Returns: バリデーション結果（true: 有効, false: 無効）
    func validate(_ input: String) -> Bool
}