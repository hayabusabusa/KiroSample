import Foundation
import CoreLocation

/// 地理座標情報
public struct Coordinate: Decodable, Sendable, Equatable {
    /// 緯度
    public let latitude: Double
    /// 経度
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// CoreLocationのCLLocationCoordinate2Dに変換
    public var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}