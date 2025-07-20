import Foundation
import Network

/// NWPathMonitorを使用したネットワーク状態監視サービスの実装
public actor NetworkService: NetworkServiceProtocol {
    private let pathMonitor: NWPathMonitor
    private let monitorQueue: DispatchQueue
    private var currentStatus: NetworkStatus = .unknown
    private var statusChangeHandler: (@Sendable (NetworkStatus) -> Void)?
    private var isMonitoring: Bool = false
    
    public init() {
        self.pathMonitor = NWPathMonitor()
        self.monitorQueue = DispatchQueue(label: "NetworkService.monitor", qos: .utility)
        
        // Actor外でpathUpdateHandlerを設定
        pathMonitor.pathUpdateHandler = { path in
            Task { [weak self] in
                await self?.handlePathUpdate(path)
            }
        }
    }
    
    deinit {
        pathMonitor.cancel()
    }
    
    // MARK: - NetworkServiceProtocol
    
    public func getCurrentNetworkStatus() async -> NetworkStatus {
        return currentStatus
    }
    
    public func startMonitoring() async {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        pathMonitor.start(queue: monitorQueue)
    }
    
    public func stopMonitoring() async {
        guard isMonitoring else { return }
        
        isMonitoring = false
        pathMonitor.cancel()
    }
    
    public func onNetworkStatusChanged(_ handler: @escaping @Sendable (NetworkStatus) -> Void) async {
        statusChangeHandler = handler
    }
    
    // MARK: - Private Methods
    
    private func handlePathUpdate(_ path: NWPath) async {
        let newStatus = convertToNetworkStatus(path)
        
        // 状態が変わった場合のみ通知
        if newStatus != currentStatus {
            currentStatus = newStatus
            statusChangeHandler?(newStatus)
        }
    }
    
    private func convertToNetworkStatus(_ path: NWPath) -> NetworkStatus {
        guard path.status == .satisfied else {
            return .unavailable
        }
        
        // 接続タイプを判定
        if path.usesInterfaceType(.wifi) {
            return .available(.wifi)
        } else if path.usesInterfaceType(.cellular) {
            return .available(.cellular)
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .available(.ethernet)
        } else {
            return .available(.other)
        }
    }
}
