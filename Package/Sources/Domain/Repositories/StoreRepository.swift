import Foundation
import SharedModels

/// 店舗データの取得・管理を行うリポジトリのプロトコル
public protocol StoreRepositoryProtocol: Sendable {
    /// 店舗一覧を取得
    /// - Returns: 店舗の配列
    /// - Throws: APIError
    func getStores() async throws -> [Store]
    
    /// 特定の店舗詳細を取得
    /// - Parameter id: 店舗ID
    /// - Returns: 店舗情報
    /// - Throws: APIError
    func getStore(by id: String) async throws -> Store
    
    /// 特定の店舗の待ち時間を更新
    /// - Parameters:
    ///   - id: 店舗ID
    ///   - waitTime: 新しい待ち時間情報
    /// - Throws: APIError
    func updateWaitTime(for id: String, waitTime: WaitTime) async throws
    
    /// キャッシュされた店舗データをクリア
    func clearCache() async
}

/// 店舗データリポジトリの実装
public final class StoreRepository: StoreRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let localStorage: LocalStorageProtocol
    private let cacheExpirationTime: TimeInterval
    
    public init(
        apiClient: APIClientProtocol,
        localStorage: LocalStorageProtocol,
        cacheExpirationTime: TimeInterval = 24 * 60 * 60 // 24時間
    ) {
        self.apiClient = apiClient
        self.localStorage = localStorage
        self.cacheExpirationTime = cacheExpirationTime
    }
    
    // MARK: - StoreRepositoryProtocol
    
    public func getStores() async throws -> [Store] {
        // キャッシュから取得を試行
        if let cachedStores = await getCachedStores(),
           await isCacheValid() {
            return cachedStores
        }
        
        // APIから取得
        do {
            let stores = try await apiClient.fetchStores()
            await cacheStores(stores)
            return stores
        } catch {
            // APIエラー時はキャッシュを返す（期限切れでも）
            if let cachedStores = await getCachedStores() {
                return cachedStores
            }
            throw error
        }
    }
    
    public func getStore(by id: String) async throws -> Store {
        // まず店舗一覧から検索
        let stores = try await getStores()
        if let store = stores.first(where: { $0.id == id }) {
            return store
        }
        
        // 見つからない場合はAPIから直接取得
        return try await apiClient.fetchStore(by: id)
    }
    
    public func updateWaitTime(for id: String, waitTime: WaitTime) async throws {
        // APIから最新の待ち時間を取得
        let newWaitTime = try await apiClient.fetchWaitTime(for: id)
        
        // キャッシュされた店舗データを更新
        if var cachedStores = await getCachedStores() {
            if let index = cachedStores.firstIndex(where: { $0.id == id }) {
                cachedStores[index].waitTime = newWaitTime
                await cacheStores(cachedStores)
            }
        }
    }
    
    public func clearCache() async {
        await localStorage.removeObject(forKey: CacheKeys.stores)
        await localStorage.removeObject(forKey: CacheKeys.lastUpdated)
    }
    
    // MARK: - Private Methods
    
    private func getCachedStores() async -> [Store]? {
        await localStorage.object(forKey: CacheKeys.stores, type: [Store].self)
    }
    
    private func cacheStores(_ stores: [Store]) async {
        await localStorage.setObject(stores, forKey: CacheKeys.stores)
        await localStorage.setObject(Date(), forKey: CacheKeys.lastUpdated)
    }
    
    private func isCacheValid() async -> Bool {
        guard let lastUpdated = await localStorage.object(forKey: CacheKeys.lastUpdated, type: Date.self) else {
            return false
        }
        return Date().timeIntervalSince(lastUpdated) < cacheExpirationTime
    }
}

// MARK: - CacheKeys

private enum CacheKeys {
    static let stores = "cached_stores"
    static let lastUpdated = "stores_last_updated"
}

