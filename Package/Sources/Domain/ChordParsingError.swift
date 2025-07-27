import Foundation

/// コード解析時に発生するエラー
public enum ChordParsingError: LocalizedError, Equatable, Sendable {
    case emptyInput
    case invalidFormat
    case unknownNote(String)
    case unknownQuality(String)
    case unknownExtension(String)
    case parsingFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "コード名を入力してください"
        case .invalidFormat:
            return "正しいコード記法で入力してください（例: C, Am, F7）"
        case .unknownNote(let note):
            return "認識できない音名です: \(note)"
        case .unknownQuality(let quality):
            return "認識できないコード品質です: \(quality)"
        case .unknownExtension(let `extension`):
            return "認識できない拡張記法です: \(`extension`)"
        case .parsingFailed(let detail):
            return "コード解析に失敗しました: \(detail)"
        }
    }
    
    /// エラー時の修正提案例
    public var suggestions: [String] {
        switch self {
        case .emptyInput, .invalidFormat:
            return ["C", "Am", "F7", "Bm7b5", "Csus4", "Gdim"]
        case .unknownNote:
            return ["C", "D", "E", "F", "G", "A", "B", "C#", "Eb"]
        case .unknownQuality:
            return ["", "m", "7", "maj7", "sus4", "dim", "aug"]
        case .unknownExtension:
            return ["7", "maj7", "9", "11", "13", "add9"]
        case .parsingFailed:
            return ["C", "Am", "F7"]
        }
    }
}