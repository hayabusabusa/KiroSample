import SwiftUI
import Domain
import SharedModels

/// 店舗一覧のViewModel
@MainActor
@Observable
public final class StoreListViewModel {
    // MARK: - Published Properties
    public var stores: [Store] = []
    public var filteredStores: [Store] = []
    public var isLoading: Bool = false
    public var lastUpdated: Date?
    public var errorMessage: String?
    public var searchQuery: String = "" {
        didSet {
            applyFilters()
        }
    }
    public var filterCriteria: FilterCriteria = FilterCriteria() {
        didSet {
            applyFilters()
        }
    }
    
    // MARK: - Dependencies
    private let storeService: StoreServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    public init(
        storeService: StoreServiceProtocol,
        networkService: NetworkServiceProtocol
    ) {
        self.storeService = storeService
        self.networkService = networkService
    }
    
    // MARK: - Public Methods
    
    /// 店舗一覧を取得・更新
    public func refreshStores() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // ネットワーク状態をチェック
            let networkStatus = await networkService.getCurrentNetworkStatus()
            guard networkStatus.isAvailable else {
                throw APIError.networkUnavailable
            }
            
            let fetchedStores = try await storeService.fetchStores()
            stores = fetchedStores
            lastUpdated = Date()
            applyFilters()
        } catch {
            errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// 特定店舗の待ち時間を更新
    public func refreshWaitTime(for storeId: String) async {
        do {
            try await storeService.refreshWaitTime(for: storeId)
            
            // 店舗一覧を再取得してUIを更新
            let updatedStores = try await storeService.fetchStores()
            stores = updatedStores
            applyFilters()
        } catch {
            errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
        }
    }
    
    /// フィルターをクリア
    public func clearFilters() {
        searchQuery = ""
        filterCriteria = FilterCriteria()
    }
    
    /// エラーメッセージをクリア
    public func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    private func applyFilters() {
        var filtered = stores
        
        // 検索クエリでフィルタ
        if !searchQuery.isEmpty {
            filtered = filtered.filter { store in
                store.name.localizedCaseInsensitiveContains(searchQuery) ||
                store.address.localizedCaseInsensitiveContains(searchQuery) ||
                store.region.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        // 最大待ち時間でフィルタ
        if let maxWaitTime = filterCriteria.maxWaitTime {
            filtered = filtered.filter { store in
                guard store.waitTime.status == .available,
                      let minutes = store.waitTime.minutes else {
                    return false
                }
                return minutes <= maxWaitTime
            }
        }
        
        // 営業中のみフィルタ
        if filterCriteria.openOnly {
            filtered = filtered.filter { store in
                store.waitTime.status == .available
            }
        }
        
        // 地域でフィルタ
        if let region = filterCriteria.region, !region.isEmpty {
            filtered = filtered.filter { store in
                store.region == region
            }
        }
        
        filteredStores = filtered
    }
}
