import Foundation
import SharedModels

/// URLSessionを使用したAPIクライアントの実装
public final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    
    public init(
        baseURL: URL = URL(string: "https://api.sawayaka.example.com")!,
        sessionConfiguration: URLSessionConfiguration? = nil
    ) {
        self.baseURL = baseURL
        let config = sessionConfiguration ?? Self.defaultSessionConfiguration()
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - APIClientProtocol
    
    public func fetchStores() async throws -> [Store] {
        let endpoint = baseURL.appendingPathComponent("/api/stores")
        return try await performRequest(url: endpoint, responseType: [Store].self)
    }
    
    public func fetchStore(by id: String) async throws -> Store {
        let endpoint = baseURL.appendingPathComponent("/api/stores/\(id)")
        return try await performRequest(url: endpoint, responseType: Store.self)
    }
    
    public func fetchWaitTime(for id: String) async throws -> WaitTime {
        let endpoint = baseURL.appendingPathComponent("/api/stores/\(id)/waittime")
        return try await performRequest(url: endpoint, responseType: WaitTime.self)
    }
    
    // MARK: - Private Methods
    
    private func performRequest<T: Decodable>(
        url: URL,
        responseType: T.Type
    ) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            do {
                return try decoder.decode(responseType, from: data)
            } catch {
                throw APIError.decodingError
            }
        } catch let error as APIError {
            throw error
        } catch {
            if error.localizedDescription.contains("timeout") ||
               error.localizedDescription.contains("timed out") {
                throw APIError.timeout
            } else {
                throw APIError.networkUnavailable
            }
        }
    }
    
    private static func defaultSessionConfiguration() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        return config
    }
}