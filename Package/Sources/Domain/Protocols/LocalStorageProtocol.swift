import Foundation

/// ローカルストレージの操作を行うプロトコル
public protocol LocalStorageProtocol: Sendable {
    /// オブジェクトを保存
    /// - Parameters:
    ///   - object: 保存するオブジェクト
    ///   - key: 保存キー
    func setObject<T: Codable>(_ object: T, forKey key: String) async
    
    /// オブジェクトを取得
    /// - Parameters:
    ///   - key: 取得キー
    ///   - type: 取得するオブジェクトの型
    /// - Returns: 取得したオブジェクト（存在しない場合はnil）
    func object<T: Codable>(forKey key: String, type: T.Type) async -> T?
    
    /// オブジェクトを削除
    /// - Parameter key: 削除キー
    func removeObject(forKey key: String) async
    
    /// 全てのオブジェクトを削除
    func removeAllObjects() async
}