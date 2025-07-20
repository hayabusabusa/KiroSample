import Foundation

/// APIエラーを表現するEnum
public enum APIError: LocalizedError, Sendable, Equatable {
    case networkUnavailable
    case invalidResponse
    case serverError(Int)
    case decodingError
    case timeout
    
    public var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "ネットワーク接続を確認してください"
        case .invalidResponse:
            return "サーバーからの応答が無効です"
        case .serverError(let code):
            return "サーバーエラー (コード: \(code))"
        case .decodingError:
            return "データの解析に失敗しました"
        case .timeout:
            return "リクエストがタイムアウトしました"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .networkUnavailable:
            return "インターネット接続が利用できません"
        case .invalidResponse:
            return "サーバーから予期しない応答を受信しました"
        case .serverError(let code):
            return "サーバーがエラーを返しました (HTTP \(code))"
        case .decodingError:
            return "受信したデータの形式が正しくありません"
        case .timeout:
            return "サーバーとの通信でタイムアウトが発生しました"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .networkUnavailable:
            return "Wi-Fiまたはモバイルデータ接続を確認し、再試行してください"
        case .invalidResponse, .decodingError:
            return "しばらく時間をおいてから再試行してください"
        case .serverError:
            return "サーバーの問題が解決されるまでお待ちください"
        case .timeout:
            return "接続状況を確認し、再試行してください"
        }
    }
}