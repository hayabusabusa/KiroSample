import Foundation
import Network

/// ネットワーク状態監視サービスのプロトコル
public protocol NetworkServiceProtocol: Sendable {
    /// 現在のネットワーク状態を取得
    /// - Returns: ネットワーク状態
    func getCurrentNetworkStatus() async -> NetworkStatus
    
    /// ネットワーク状態の監視を開始
    func startMonitoring() async
    
    /// ネットワーク状態の監視を停止
    func stopMonitoring() async
    
    /// ネットワーク状態変更の通知を受け取る
    /// - Parameter handler: 状態変更時のハンドラー
    func onNetworkStatusChanged(_ handler: @escaping @Sendable (NetworkStatus) -> Void) async
}

/// ネットワーク状態
public enum NetworkStatus: Sendable, Equatable {
    case available(ConnectionType)
    case unavailable
    case unknown
    
    /// 接続タイプ
    public enum ConnectionType: Sendable, Equatable {
        case wifi
        case cellular
        case ethernet
        case other
    }
    
    /// ネットワークが利用可能かどうか
    public var isAvailable: Bool {
        switch self {
        case .available:
            return true
        case .unavailable, .unknown:
            return false
        }
    }
}