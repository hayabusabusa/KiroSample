import Foundation
import SharedModels

/// テスト用のMock APIClient実装
public final class MockAPIClient: APIClientProtocol {
    private let mockStores: [Store]
    private let simulateNetworkDelay: Bool
    private let networkDelayRange: ClosedRange<Double>
    
    public init(
        simulateNetworkDelay: Bool = true,
        networkDelayRange: ClosedRange<Double> = 0.5...2.0
    ) {
        self.simulateNetworkDelay = simulateNetworkDelay
        self.networkDelayRange = networkDelayRange
        self.mockStores = Self.createMockStores()
    }
    
    // MARK: - APIClientProtocol
    
    public func fetchStores() async throws -> [Store] {
        if simulateNetworkDelay {
            let delay = Double.random(in: networkDelayRange)
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        // ランダムに待ち時間を更新
        return mockStores.map { store in
            var updatedStore = store
            updatedStore.waitTime = generateRandomWaitTime()
            return updatedStore
        }
    }
    
    public func fetchStore(by id: String) async throws -> Store {
        if simulateNetworkDelay {
            let delay = Double.random(in: networkDelayRange)
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        guard var store = mockStores.first(where: { $0.id == id }) else {
            throw APIError.invalidResponse
        }
        
        // ランダムに待ち時間を更新
        store.waitTime = generateRandomWaitTime()
        return store
    }
    
    public func fetchWaitTime(for id: String) async throws -> WaitTime {
        if simulateNetworkDelay {
            let delay = Double.random(in: networkDelayRange)
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        guard mockStores.contains(where: { $0.id == id }) else {
            throw APIError.invalidResponse
        }
        
        return generateRandomWaitTime()
    }
    
    // MARK: - Private Methods
    
    private func generateRandomWaitTime() -> WaitTime {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        // 営業時間外（23時〜11時）
        if currentHour >= 23 || currentHour < 11 {
            return WaitTime(
                minutes: nil,
                status: .closed,
                lastUpdated: Date()
            )
        }
        
        // ランダムで営業状況を決定（95%の確率で営業中）
        let isAvailable = Double.random(in: 0...1) < 0.95
        
        guard isAvailable else {
            return WaitTime(
                minutes: nil,
                status: .unavailable,
                lastUpdated: Date()
            )
        }
        
        // 営業中の場合、ランダムな待ち時間を生成
        let waitMinutes = Int.random(in: 0...120)
        
        return WaitTime(
            minutes: waitMinutes,
            status: .available,
            lastUpdated: Date()
        )
    }
    
    private static func createMockStores() -> [Store] {
        return [
            // 静岡市内
            Store(
                id: "shizuoka-inter",
                name: "さわやか 静岡インター店",
                address: "静岡県静岡市駿河区中島1077-1",
                phoneNumber: "054-286-5989",
                coordinate: Coordinate(latitude: 34.9297, longitude: 138.3969),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 25, status: .available, lastUpdated: Date()),
                region: "静岡市"
            ),
            Store(
                id: "aoba-dori",
                name: "さわやか 青葉通り店",
                address: "静岡県静岡市葵区七間町7-8",
                phoneNumber: "054-255-5963",
                coordinate: Coordinate(latitude: 34.9769, longitude: 138.3822),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 15, status: .available, lastUpdated: Date()),
                region: "静岡市"
            ),
            Store(
                id: "shimizu-eki-mae",
                name: "さわやか 清水駅前店",
                address: "静岡県静岡市清水区真砂町4-18",
                phoneNumber: "054-367-5963",
                coordinate: Coordinate(latitude: 35.0186, longitude: 138.4867),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 40, status: .available, lastUpdated: Date()),
                region: "静岡市"
            ),
            
            // 浜松市内
            Store(
                id: "hamamatsu-eki-minami",
                name: "さわやか 浜松駅南店",
                address: "静岡県浜松市中区砂山町348-38",
                phoneNumber: "053-456-5963",
                coordinate: Coordinate(latitude: 34.7024, longitude: 137.7347),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 35, status: .available, lastUpdated: Date()),
                region: "浜松市"
            ),
            Store(
                id: "hamamatsu-nishi",
                name: "さわやか 浜松西店",
                address: "静岡県浜松市西区大平台3-21-1",
                phoneNumber: "053-485-5963",
                coordinate: Coordinate(latitude: 34.7308, longitude: 137.6556),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 20, status: .available, lastUpdated: Date()),
                region: "浜松市"
            ),
            Store(
                id: "enshu-yamaha",
                name: "さわやか 遠鉄ヤマハ店",
                address: "静岡県浜松市中区中沢町10-1 遠鉄百貨店新館8F",
                phoneNumber: "053-457-5963",
                coordinate: Coordinate(latitude: 34.7047, longitude: 137.7379),
                businessHours: BusinessHours(weekday: "11:00-21:00", weekend: "11:00-21:00", holiday: "11:00-21:00"),
                waitTime: WaitTime(minutes: 50, status: .available, lastUpdated: Date()),
                region: "浜松市"
            ),
            
            // 焼津・藤枝市
            Store(
                id: "yaizu",
                name: "さわやか 焼津店",
                address: "静岡県焼津市八楠4-31-1",
                phoneNumber: "054-629-5963",
                coordinate: Coordinate(latitude: 34.8636, longitude: 138.3219),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 30, status: .available, lastUpdated: Date()),
                region: "焼津市"
            ),
            Store(
                id: "fujieda",
                name: "さわやか 藤枝店",
                address: "静岡県藤枝市田沼3-22-1",
                phoneNumber: "054-644-5963",
                coordinate: Coordinate(latitude: 34.8664, longitude: 138.2642),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 10, status: .available, lastUpdated: Date()),
                region: "藤枝市"
            ),
            
            // 沼津・三島市
            Store(
                id: "numazu",
                name: "さわやか 沼津店",
                address: "静岡県沼津市高島本町12-5",
                phoneNumber: "055-929-5963",
                coordinate: Coordinate(latitude: 35.0956, longitude: 138.8637),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 45, status: .available, lastUpdated: Date()),
                region: "沼津市"
            ),
            Store(
                id: "mishima",
                name: "さわやか 三島店",
                address: "静岡県三島市安久322-1",
                phoneNumber: "055-991-5963",
                coordinate: Coordinate(latitude: 35.1303, longitude: 138.9031),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 60, status: .available, lastUpdated: Date()),
                region: "三島市"
            ),
            
            // その他地域
            Store(
                id: "iwata",
                name: "さわやか 磐田店",
                address: "静岡県磐田市見付2681-1",
                phoneNumber: "0538-37-5963",
                coordinate: Coordinate(latitude: 34.7167, longitude: 137.8511),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 15, status: .available, lastUpdated: Date()),
                region: "磐田市"
            ),
            Store(
                id: "kakegawa",
                name: "さわやか 掛川店",
                address: "静岡県掛川市中央2-4-27",
                phoneNumber: "0537-23-5963",
                coordinate: Coordinate(latitude: 34.7697, longitude: 138.0119),
                businessHours: BusinessHours(weekday: "11:00-23:00", weekend: "11:00-23:00", holiday: "11:00-23:00"),
                waitTime: WaitTime(minutes: 25, status: .available, lastUpdated: Date()),
                region: "掛川市"
            )
        ]
    }
}