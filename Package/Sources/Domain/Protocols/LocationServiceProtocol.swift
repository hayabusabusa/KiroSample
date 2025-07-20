import Foundation
import CoreLocation

/// 位置情報サービスのプロトコル
public protocol LocationServiceProtocol: Sendable {
    /// 現在の位置情報を取得
    /// - Returns: 現在の座標
    /// - Throws: LocationError
    func getCurrentLocation() async throws -> CLLocationCoordinate2D
    
    /// 位置情報の使用許可状況を確認
    /// - Returns: 許可状況
    func getAuthorizationStatus() -> CLAuthorizationStatus
    
    /// 位置情報の使用許可を要求
    func requestLocationPermission() async
    
    /// 2点間の距離を計算（メートル）
    /// - Parameters:
    ///   - from: 開始座標
    ///   - to: 終了座標
    /// - Returns: 距離（メートル）
    func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double
}

/// 位置情報関連のエラー
public enum LocationError: LocalizedError, Sendable, Equatable {
    case permissionDenied
    case locationUnavailable
    case timeout
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "位置情報の使用が許可されていません"
        case .locationUnavailable:
            return "位置情報を取得できませんでした"
        case .timeout:
            return "位置情報の取得がタイムアウトしました"
        case .unknown:
            return "不明なエラーが発生しました"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .permissionDenied:
            return "設定アプリで位置情報の使用を許可してください"
        case .locationUnavailable:
            return "GPS信号の良い場所で再試行してください"
        case .timeout:
            return "時間をおいて再試行してください"
        case .unknown:
            return "アプリを再起動して再試行してください"
        }
    }
}