import Foundation
import SharedModels

/// コード文字列を解析してChordオブジェクトを生成するパーサー
public final class ChordParser: ChordParserProtocol {
    
    // 正規表現パターン定義
    private let notePattern = "([A-G][#b]?)"
    private let qualityPattern = "(m7b5|mMaj7|maj13|maj11|maj9|maj7|dim7|aug7|m13|m11|m9|m7|add9|sus4|sus2|aug|dim|13|11|9|7|m)?"
    private let bassPattern = "(/([A-G][#b]?))?"
    
    public init() {}
    
    public func parse(_ input: String) throws -> Chord {
        guard !input.isEmpty else {
            throw ChordParsingError.emptyInput
        }
        
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ChordParsingError.emptyInput
        }
        let pattern = "^\(notePattern)\(qualityPattern)\(bassPattern)$"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            throw ChordParsingError.parsingFailed("正規表現の作成に失敗")
        }
        
        let range = NSRange(trimmed.startIndex..., in: trimmed)
        guard let match = regex.firstMatch(in: trimmed, options: [], range: range) else {
            throw ChordParsingError.invalidFormat
        }
        
        // ルート音の解析
        let root = try parseRequiredNote(from: trimmed, match: match, groupIndex: 1)
        
        // コード品質の解析
        let quality = try parseQuality(from: trimmed, match: match, groupIndex: 2)
        
        // ベース音の解析（オプショナル）
        let bass = try parseOptionalNote(from: trimmed, match: match, groupIndex: 4)
        
        return Chord(root: root, quality: quality, extensions: [], bass: bass)
    }
    
    public func validate(_ input: String) -> Bool {
        do {
            _ = try parse(input)
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func parseRequiredNote(from input: String, match: NSTextCheckingResult, groupIndex: Int) throws -> Note {
        let noteRange = match.range(at: groupIndex)
        
        guard noteRange.location != NSNotFound else {
            throw ChordParsingError.parsingFailed("音名が見つかりません")
        }
        
        guard let range = Range(noteRange, in: input) else {
            throw ChordParsingError.parsingFailed("音名の範囲取得に失敗")
        }
        
        let noteString = String(input[range])
        
        // 音名を正規化（最初の文字を大文字に、#bはそのまま）
        let normalizedNoteString = noteString.prefix(1).uppercased() + noteString.dropFirst()
        
        // Note enumから一致する音名を検索
        guard let note = Note.allCases.first(where: { $0.name == normalizedNoteString }) else {
            throw ChordParsingError.unknownNote(normalizedNoteString)
        }
        
        return note
    }
    
    private func parseOptionalNote(from input: String, match: NSTextCheckingResult, groupIndex: Int) throws -> Note? {
        let noteRange = match.range(at: groupIndex)
        
        guard noteRange.location != NSNotFound else {
            return nil
        }
        
        guard let range = Range(noteRange, in: input) else {
            return nil
        }
        
        let noteString = String(input[range])
        
        // 音名を正規化（最初の文字を大文字に、#bはそのまま）
        let normalizedNoteString = noteString.prefix(1).uppercased() + noteString.dropFirst()
        
        // Note enumから一致する音名を検索
        guard let note = Note.allCases.first(where: { $0.name == normalizedNoteString }) else {
            throw ChordParsingError.unknownNote(normalizedNoteString)
        }
        
        return note
    }
    
    private func parseQuality(from input: String, match: NSTextCheckingResult, groupIndex: Int) throws -> ChordQuality {
        let qualityRange = match.range(at: groupIndex)
        
        // 品質が指定されていない場合はメジャーコード
        guard qualityRange.location != NSNotFound else {
            return .major
        }
        
        guard let range = Range(qualityRange, in: input) else {
            return .major
        }
        
        let qualityString = String(input[range]).lowercased()
        
        // 空文字列の場合はメジャーコード
        if qualityString.isEmpty {
            return .major
        }
        
        // ChordQuality enumから一致する品質を検索（大文字小文字無視）
        guard let quality = ChordQuality.allCases.first(where: { $0.symbol.lowercased() == qualityString }) else {
            throw ChordParsingError.unknownQuality(qualityString)
        }
        
        return quality
    }
}