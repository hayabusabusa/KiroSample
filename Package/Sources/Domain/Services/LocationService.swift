import Foundation
import CoreLocation

/// CoreLocationを使用した位置情報サービスの実装
public final class LocationService: NSObject, LocationServiceProtocol, @unchecked Sendable {
    private let locationManager: CLLocationManager
    private let timeout: TimeInterval
    
    // async/await用の継続
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var permissionContinuation: CheckedContinuation<Void, Never>?
    
    public init(timeout: TimeInterval = 10.0) {
        self.locationManager = CLLocationManager()
        self.timeout = timeout
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // 100m移動したら更新
    }
    
    // MARK: - LocationServiceProtocol
    
    public func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        // 権限チェック
        let status = getAuthorizationStatus()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            throw LocationError.permissionDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            
            // タイムアウト設定
            Task {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                if let locationContinuation = locationContinuation {
                    self.locationContinuation = nil
                    locationContinuation.resume(throwing: LocationError.timeout)
                }
            }
            
            locationManager.requestLocation()
        }
    }
    
    public func getAuthorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    public func requestLocationPermission() async {
        guard getAuthorizationStatus() == .notDetermined else {
            return
        }
        
        await withCheckedContinuation { continuation in
            permissionContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
              let continuation = locationContinuation else {
            return
        }
        
        locationContinuation = nil
        continuation.resume(returning: location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let continuation = locationContinuation else {
            return
        }
        
        locationContinuation = nil
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                continuation.resume(throwing: LocationError.permissionDenied)
            case .locationUnknown, .network:
                continuation.resume(throwing: LocationError.locationUnavailable)
            default:
                continuation.resume(throwing: LocationError.unknown)
            }
        } else {
            continuation.resume(throwing: LocationError.unknown)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        permissionContinuation?.resume()
        permissionContinuation = nil
    }
}