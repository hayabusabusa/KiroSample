//
//  KeySuggestionViewModel.swift
//  KeySuggestionFeature
//
//  Created by Shunya Yamada on 2025/07/21.
//

import Foundation
import Observation
import Domain
import SharedModels

@Observable
@MainActor
public final class KeySuggestionViewModel {
    public var chordInput: String = ""
    public var errorMessage: String?
    public var suggestedKeys: [KeySuggestion] = []
    public var diatonicChords: [DiatonicChord] = []
    public var selectedKey: Key?
    
    // キー提案表示とソート機能
    public var sortOrder: KeySuggestionSortOrder = .byScore
    public var maxSuggestionsToShow: Int = 12
    public var showOnlyStandardKeys: Bool = false
    
    // 選択状態管理と説明表示
    public var selectedSuggestion: KeySuggestion?
    public var showDetailedExplanation: Bool = false
    
    private let chordParser: ChordParserProtocol
    private let keySuggestionService: KeySuggestionServiceProtocol
    private let diatonicChordService: DiatonicChordServiceProtocol
    
    public init(
        chordParser: ChordParserProtocol = ChordParser(),
        keySuggestionService: KeySuggestionServiceProtocol = KeySuggestionService(),
        diatonicChordService: DiatonicChordServiceProtocol = DiatonicChordService()
    ) {
        self.chordParser = chordParser
        self.keySuggestionService = keySuggestionService
        self.diatonicChordService = diatonicChordService
    }
    
    public func validateInput(_ input: String) {
        // リアルタイムバリデーション
        if input.isEmpty {
            errorMessage = nil
            suggestedKeys = []
            return
        }
        
        // 簡単なバリデーション
        let validPattern = "^[A-G][#b]?[^/]*((/[A-G][#b]?)?)$"
        guard let regex = try? NSRegularExpression(pattern: validPattern) else {
            errorMessage = "正規表現エラー"
            return
        }
        
        let range = NSRange(location: 0, length: input.utf16.count)
        
        if regex.firstMatch(in: input, range: range) == nil {
            errorMessage = "正しいコード記法で入力してください（例: C, Am, F7）"
        } else {
            errorMessage = nil
        }
    }
    
    public func processChordInput() async {
        guard errorMessage == nil, !chordInput.isEmpty else { return }
        
        do {
            let chord = try chordParser.parse(chordInput)
            let allSuggestions = await keySuggestionService.suggestKeys(for: chord)
            suggestedKeys = applySortingAndFiltering(to: allSuggestions)
            
            // 選択状態をリセット
            selectedSuggestion = nil
            selectedKey = nil
            diatonicChords = []
        } catch {
            if let chordError = error as? ChordParsingError {
                errorMessage = chordError.localizedDescription
            } else {
                errorMessage = "コード解析エラー: \(error.localizedDescription)"
            }
            suggestedKeys = []
            selectedSuggestion = nil
            selectedKey = nil
            diatonicChords = []
        }
    }
    
    public func selectKey(_ key: Key) async {
        selectedKey = key
        diatonicChords = await diatonicChordService.generateDiatonicChords(for: key)
    }
    
    // MARK: - キー提案表示とソート機能
    
    /// キー提案を選択する
    /// - Parameter suggestion: 選択するキー提案
    public func selectSuggestion(_ suggestion: KeySuggestion) async {
        selectedSuggestion = suggestion
        await selectKey(suggestion.key)
    }
    
    /// ソート順序を変更して提案リストを更新
    /// - Parameter newSortOrder: 新しいソート順序
    public func changeSortOrder(to newSortOrder: KeySuggestionSortOrder) {
        sortOrder = newSortOrder
        suggestedKeys = applySortingAndFiltering(to: suggestedKeys)
    }
    
    /// 標準キーフィルターを切り替え
    public func toggleStandardKeysFilter() {
        showOnlyStandardKeys.toggle()
        suggestedKeys = applySortingAndFiltering(to: suggestedKeys)
    }
    
    /// 詳細説明の表示/非表示を切り替え
    public func toggleDetailedExplanation() {
        showDetailedExplanation.toggle()
    }
    
    // MARK: - ダイアトニックコード機能
    
    /// ダイアトニックコードを選択して新規検索を実行
    /// - Parameter diatonicChord: 選択されたダイアトニックコード
    public func selectDiatonicChord(_ diatonicChord: DiatonicChord) async {
        // 選択されたコードの文字列表現を取得
        chordInput = diatonicChord.chord.symbol
        
        // 入力バリデーションを実行
        validateInput(chordInput)
        
        // エラーがなければコード処理を実行
        if errorMessage == nil {
            await processChordInput()
        }
    }
    
    /// 現在選択されているキーのダイアトニックコードリストを再読み込み
    public func refreshDiatonicChords() async {
        guard let selectedKey = selectedKey else { return }
        diatonicChords = await diatonicChordService.generateDiatonicChords(for: selectedKey)
    }
    
    // MARK: - Private Helper Methods
    
    /// キー提案にソートとフィルタリングを適用
    /// - Parameter suggestions: 元のキー提案配列
    /// - Returns: ソート・フィルタリング済みのキー提案配列
    private func applySortingAndFiltering(to suggestions: [KeySuggestion]) -> [KeySuggestion] {
        var filteredSuggestions = suggestions
        
        // 標準キーフィルタを適用
        if showOnlyStandardKeys {
            filteredSuggestions = filteredSuggestions.filter { isStandardKey($0.key) }
        }
        
        // ソートを適用
        switch sortOrder {
        case .byScore:
            filteredSuggestions.sort { $0.score > $1.score }
        case .byKeyName:
            filteredSuggestions.sort { $0.key.name < $1.key.name }
        case .byMode:
            filteredSuggestions.sort { suggestion1, suggestion2 in
                if suggestion1.key.mode != suggestion2.key.mode {
                    return suggestion1.key.mode == .major
                }
                return suggestion1.key.name < suggestion2.key.name
            }
        }
        
        // 表示数制限を適用
        return Array(filteredSuggestions.prefix(maxSuggestionsToShow))
    }
    
    /// 標準的なキー（よく使われるキー）かどうかを判定
    /// - Parameter key: 判定対象のキー
    /// - Returns: 標準キーの場合true
    private func isStandardKey(_ key: Key) -> Bool {
        // よく使われるキーを定義（シャープ・フラット2個まで）
        let standardTonics: [Note] = [.c, .g, .d, .a, .e, .b, .f]
        return standardTonics.contains(key.tonic)
    }
}

// MARK: - Computed Properties

public extension KeySuggestionViewModel {
    /// 表示用のキー提案リスト（追加情報付き）
    var displaySuggestions: [DisplayKeySuggestion] {
        return suggestedKeys.map { suggestion in
            DisplayKeySuggestion(
                suggestion: suggestion,
                isSelected: suggestion.key == selectedKey,
                confidenceLevel: getConfidenceLevel(for: suggestion.score),
                detailedReason: showDetailedExplanation ? getDetailedReason(for: suggestion) : nil
            )
        }
    }
    
    /// 現在選択されているキーの詳細情報
    var selectedKeyInfo: SelectedKeyInfo? {
        guard let selectedKey = selectedKey,
              let selectedSuggestion = selectedSuggestion else { return nil }
        
        return SelectedKeyInfo(
            key: selectedKey,
            suggestion: selectedSuggestion,
            diatonicChords: diatonicChords
        )
    }
    
    /// ダイアトニックコードが選択可能かどうか
    var hasDiatonicChords: Bool {
        return !diatonicChords.isEmpty
    }
    
    /// ダイアトニックコードを度数順でグループ化
    var diatonicChordsByDegree: [(ScaleDegree, DiatonicChord)] {
        return diatonicChords.map { chord in
            (chord.degree, chord)
        }.sorted { $0.0.rawValue < $1.0.rawValue }
    }
    
    /// ハーモニック機能別にダイアトニックコードをグループ化
    var diatonicChordsByFunction: [HarmonicFunction: [DiatonicChord]] {
        return Dictionary(grouping: diatonicChords) { $0.function }
    }
}

// MARK: - Private Helper Methods Extension

private extension KeySuggestionViewModel {
    /// スコアから信頼度レベルを取得
    func getConfidenceLevel(for score: Double) -> ConfidenceLevel {
        switch score {
        case 12...:
            return .veryHigh
        case 10..<12:
            return .high
        case 7..<10:
            return .medium
        case 5..<7:
            return .low
        default:
            return .veryLow
        }
    }
    
    /// 詳細な理由説明を生成
    func getDetailedReason(for suggestion: KeySuggestion) -> String {
        let confidenceLevel = getConfidenceLevel(for: suggestion.score)
        let confidenceText = confidenceLevel.description
        
        return "\(suggestion.reason)\n信頼度: \(confidenceText) (スコア: \(String(format: "%.1f", suggestion.score)))"
    }
}
