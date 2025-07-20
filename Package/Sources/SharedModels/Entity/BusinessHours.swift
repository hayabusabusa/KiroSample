import Foundation

/// 店舗の営業時間情報
public struct BusinessHours: Decodable, Sendable, Equatable {
    /// 平日営業時間（例: "11:00-23:00"）
    public let weekday: String
    /// 週末営業時間（例: "11:00-23:00"）
    public let weekend: String
    /// 祝日営業時間（例: "11:00-22:00"）。祝日営業していない場合はnil
    public let holiday: String?
    
    public init(weekday: String, weekend: String, holiday: String?) {
        self.weekday = weekday
        self.weekend = weekend
        self.holiday = holiday
    }
}