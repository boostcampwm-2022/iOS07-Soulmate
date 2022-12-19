//
//  NetworkManager.swift
//  Soulmate
//
//  Created by termblur on 2022/12/10.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private var queue = DispatchQueue.global()
    private var monitor: NWPathMonitor
    private(set) var isConnected: Bool = true
    private(set) var connectionType:ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConenctionType(path)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }

    private func getConenctionType(_ path:NWPath) {
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
    deinit {
        stopMonitoring()
    }
}
