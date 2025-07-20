import Foundation
import SwiftUI

/// 店舗の待ち時間情報
public struct WaitTime: Codable, Sendable, Equatable {
    /// 待ち時間（分）。営業時間外や取得不可の場合はnil
    public let minutes: Int?
    /// 待ち時間のステータス
    public let status: WaitStatus
    /// 最終更新日時
    public let lastUpdated: Date
    
    /// 待ち時間の状態を表すEnum
    public enum WaitStatus: String, Codable, Sendable, CaseIterable, Equatable {
        case available = "available"      // 営業中
        case closed = "closed"           // 営業時間外
        case unavailable = "unavailable" // データ取得不可
    }
    
    public init(minutes: Int?, status: WaitStatus, lastUpdated: Date) {
        self.minutes = minutes
        self.status = status
        self.lastUpdated = lastUpdated
    }
    
    /// 待ち時間に応じた表示色を取得
    public var colorCode: Color {
        switch status {
        case .available:
            guard let minutes = minutes else { return .gray }
            if minutes <= 30 { return .green }
            else if minutes <= 60 { return .yellow }
            else { return .red }
        case .closed, .unavailable:
            return .gray
        }
    }
}