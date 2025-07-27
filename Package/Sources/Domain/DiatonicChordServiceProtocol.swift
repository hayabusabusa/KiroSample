import Foundation
import SharedModels

/// ダイアトニックコード生成機能を提供するサービスのプロトコル
public protocol DiatonicChordServiceProtocol: Sendable {
    /// 指定されたキーのダイアトニックコード一覧を生成する
    /// - Parameter key: ダイアトニックコードを生成するキー
    /// - Returns: ダイアトニックコードの配列（I, ii, iii, IV, V, vi, vii°の順）
    func generateDiatonicChords(for key: Key) async -> [DiatonicChord]
    
    /// 直接計算でダイアトニックコードを生成する（キャッシュをバイパス）
    /// - Parameter key: ダイアトニックコードを生成するキー
    /// - Returns: ダイアトニックコードの配列
    func generateDiatonicChordsDirectly(for key: Key) -> [DiatonicChord]
}