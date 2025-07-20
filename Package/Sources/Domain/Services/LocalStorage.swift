import Foundation

/// UserDefaultsを使用したローカルストレージの実装
public final class LocalStorage: LocalStorageProtocol, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - LocalStorageProtocol
    
    public func setObject<T: Codable>(_ object: T, forKey key: String) async {
        do {
            let data = try encoder.encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to encode object for key \(key): \(error)")
        }
    }
    
    public func object<T: Codable>(forKey key: String, type: T.Type) async -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print("Failed to decode object for key \(key): \(error)")
            return nil
        }
    }
    
    public func removeObject(forKey key: String) async {
        userDefaults.removeObject(forKey: key)
    }
    
    public func removeAllObjects() async {
        let keys = userDefaults.dictionaryRepresentation().keys
        for key in keys {
            userDefaults.removeObject(forKey: key)
        }
    }
}