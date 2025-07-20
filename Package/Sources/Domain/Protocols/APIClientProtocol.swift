import Foundation
import SharedModels

/// API通信を行うクライアントのプロトコル
public protocol APIClientProtocol: Sendable {
    /// 店舗一覧を取得
    /// - Returns: 店舗の配列
    /// - Throws: APIError
    func fetchStores() async throws -> [Store]
    
    /// 特定の店舗詳細を取得
    /// - Parameter id: 店舗ID
    /// - Returns: 店舗情報
    /// - Throws: APIError
    func fetchStore(by id: String) async throws -> Store
    
    /// 特定の店舗の待ち時間を取得
    /// - Parameter id: 店舗ID
    /// - Returns: 待ち時間情報
    /// - Throws: APIError
    func fetchWaitTime(for id: String) async throws -> WaitTime
}