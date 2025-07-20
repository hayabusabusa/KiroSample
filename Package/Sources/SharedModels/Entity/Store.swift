import Foundation

/// さわやか店舗の情報を表現するモデル
public struct Store: Identifiable, Decodable, Sendable, Equatable {
    /// 店舗の一意識別子
    public let id: String
    /// 店舗名（例: "さわやか 静岡インター店"）
    public let name: String
    /// 店舗住所
    public let address: String
    /// 店舗電話番号（ハイフンあり形式）
    public let phoneNumber: String
    /// 店舗の座標情報
    public let coordinate: Coordinate
    /// 営業時間情報
    public let businessHours: BusinessHours
    /// 現在の待ち時間情報（変更可能）
    public var waitTime: WaitTime
    /// 地域区分（例: "静岡市", "浜松市"）
    public let region: String
    
    public init(
        id: String,
        name: String,
        address: String,
        phoneNumber: String,
        coordinate: Coordinate,
        businessHours: BusinessHours,
        waitTime: WaitTime,
        region: String
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.coordinate = coordinate
        self.businessHours = businessHours
        self.waitTime = waitTime
        self.region = region
    }
}
