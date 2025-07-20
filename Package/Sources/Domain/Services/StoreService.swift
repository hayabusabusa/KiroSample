import Foundation
import SharedModels

/// 店舗データの取得・管理を行うサービスのプロトコル
public protocol StoreServiceProtocol: Sendable {
    /// 店舗一覧を取得
    /// - Returns: 店舗の配列
    /// - Throws: APIError
    func fetchStores() async throws -> [Store]
    
    /// 特定の店舗詳細を取得
    /// - Parameter id: 店舗ID
    /// - Returns: 店舗情報
    /// - Throws: APIError
    func fetchStoreDetail(id: String) async throws -> Store
    
    /// 店舗の待ち時間を更新
    /// - Parameter id: 店舗ID
    /// - Throws: APIError
    func refreshWaitTime(for id: String) async throws
    
    /// キャッシュをクリア
    func clearCache() async
}

/// Actor-basedな店舗データサービスの実装
public actor StoreService: StoreServiceProtocol {
    private let repository: StoreRepositoryProtocol
    private var cachedStores: [Store] = []
    private var lastFetchTime: Date?
    private let cacheValidityDuration: TimeInterval
    
    public init(
        repository: StoreRepositoryProtocol,
        cacheValidityDuration: TimeInterval = 5 * 60 // 5分
    ) {
        self.repository = repository
        self.cacheValidityDuration = cacheValidityDuration
    }
    
    // MARK: - StoreServiceProtocol
    
    public func fetchStores() async throws -> [Store] {
        // キャッシュが有効な場合はキャッシュを返す
        if isCacheValid(), !cachedStores.isEmpty {
            return cachedStores
        }
        
        // Repositoryから取得
        let stores = try await repository.getStores()
        
        // キャッシュを更新
        cachedStores = stores
        lastFetchTime = Date()
        
        return stores
    }
    
    public func fetchStoreDetail(id: String) async throws -> Store {
        // まずキャッシュから検索
        if let cachedStore = cachedStores.first(where: { $0.id == id }),
           isCacheValid() {
            return cachedStore
        }
        
        // Repositoryから取得
        let store = try await repository.getStore(by: id)
        
        // キャッシュを更新
        updateStoreInCache(store)
        
        return store
    }
    
    public func refreshWaitTime(for id: String) async throws {
        // 待ち時間を更新（ダミーの新しい待ち時間を作成）
        let newWaitTime = WaitTime(
            minutes: Int.random(in: 0...120),
            status: .available,
            lastUpdated: Date()
        )
        
        try await repository.updateWaitTime(for: id, waitTime: newWaitTime)
        
        // キャッシュされた店舗の待ち時間も更新
        if let index = cachedStores.firstIndex(where: { $0.id == id }) {
            cachedStores[index].waitTime = newWaitTime
        }
    }
    
    public func clearCache() async {
        cachedStores.removeAll()
        lastFetchTime = nil
        await repository.clearCache()
    }
    
    // MARK: - Private Methods
    
    private func isCacheValid() -> Bool {
        guard let lastFetchTime = lastFetchTime else {
            return false
        }
        return Date().timeIntervalSince(lastFetchTime) < cacheValidityDuration
    }
    
    private func updateStoreInCache(_ store: Store) {
        if let index = cachedStores.firstIndex(where: { $0.id == store.id }) {
            cachedStores[index] = store
        } else {
            cachedStores.append(store)
        }
        lastFetchTime = Date()
    }
}

