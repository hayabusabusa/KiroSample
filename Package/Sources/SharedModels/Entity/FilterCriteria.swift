import Foundation

/// 店舗検索・フィルタリング用の条件
public struct FilterCriteria: Sendable, Equatable {
    /// 最大待ち時間（分）。指定した時間以下の店舗のみ表示
    public var maxWaitTime: Int? = nil
    /// 営業中の店舗のみ表示するかどうか
    public var openOnly: Bool = false
    /// 地域フィルター（例: "静岡市"）
    public var region: String? = nil
    /// 検索クエリ（店舗名での部分一致検索）
    public var searchQuery: String = ""
    
    public init(
        maxWaitTime: Int? = nil,
        openOnly: Bool = false,
        region: String? = nil,
        searchQuery: String = ""
    ) {
        self.maxWaitTime = maxWaitTime
        self.openOnly = openOnly
        self.region = region
        self.searchQuery = searchQuery
    }
}