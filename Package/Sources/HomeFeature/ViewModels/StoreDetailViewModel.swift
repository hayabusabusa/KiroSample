import SwiftUI
import MapKit
import Domain
import SharedModels

/// 店舗詳細のViewModel
@MainActor
@Observable
public final class StoreDetailViewModel {
    // MARK: - Published Properties
    public var store: Store?
    public var isLoading: Bool = false
    public var errorMessage: String?
    public var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    // MARK: - Dependencies
    private let storeService: StoreServiceProtocol
    private let locationService: LocationServiceProtocol
    
    public init(
        storeService: StoreServiceProtocol,
        locationService: LocationServiceProtocol
    ) {
        self.storeService = storeService
        self.locationService = locationService
    }
    
    // MARK: - Public Methods
    
    /// 店舗詳細を読み込み
    public func loadStoreDetail(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedStore = try await storeService.fetchStoreDetail(id: id)
            store = fetchedStore
            setupMapRegion()
        } catch {
            errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// 電話をかける
    public func makePhoneCall(phoneNumber: String) {
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        
        guard let url = URL(string: "tel://\(cleanedNumber)"),
              UIApplication.shared.canOpenURL(url) else {
            errorMessage = "電話アプリを起動できませんでした"
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    /// マップアプリで開く
    public func openInMaps() {
        guard let store = store else { return }
        
        let coordinate = store.coordinate.clLocationCoordinate2D
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = store.name
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    /// 現在地からの距離を計算
    public func calculateDistanceFromCurrentLocation() async -> String? {
        guard let store = store else { return nil }
        
        do {
            let currentLocation = try await locationService.getCurrentLocation()
            let storeCoordinate = store.coordinate.clLocationCoordinate2D
            let distance = locationService.calculateDistance(
                from: currentLocation,
                to: storeCoordinate
            )
            
            // 距離を適切な単位で表示
            if distance < 1000 {
                return String(format: "%.0fm", distance)
            } else {
                return String(format: "%.1fkm", distance / 1000)
            }
        } catch {
            return nil
        }
    }
    
    /// 店舗の待ち時間を更新
    public func refreshWaitTime() async {
        guard let storeId = store?.id else { return }
        
        do {
            try await storeService.refreshWaitTime(for: storeId)
            
            // 店舗情報を再取得してUIを更新
            let updatedStore = try await storeService.fetchStoreDetail(id: storeId)
            store = updatedStore
        } catch {
            errorMessage = (error as? APIError)?.localizedDescription ?? error.localizedDescription
        }
    }
    
    /// エラーメッセージをクリア
    public func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Private Methods
    
    private func setupMapRegion() {
        guard let store = store else { return }
        
        let coordinate = store.coordinate.clLocationCoordinate2D
        mapRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
}