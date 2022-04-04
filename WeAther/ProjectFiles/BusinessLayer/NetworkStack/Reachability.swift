//
//  Network.swift
//  CheckNetwork
//
//  Created by Red Apple Technologies Private Limited on 21/12/20.
//

import Foundation
import Network
import UIKit

class Reachability {
    static let shared = Reachability()
    private var monitor: NWPathMonitor?
    private var isMonitoring = false
    var didStartMonitoringHandler: (() -> Void)?
    var didStopMonitoringHandler: (() -> Void)?
    var networkStatusChangeHandler: ((NWPath.Status) -> Void)?
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    private var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    var interfaceType: NWInterface.InterfaceType? {
        return self.availableInterfacesTypes?.first
    }
    // MARK: - Initializer
    private init () {}
    deinit {
        stopMonitoring()
    }
}

// MARK: - Public methods
extension Reachability {
    public final func startMonitoring(_ status: ((NWPath.Status) -> Void)?) {
        networkStatusChangeHandler = status
        if isMonitoring { return }
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor?.start(queue: queue)
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.networkStatusChangeHandler?(path.status)
            }
        }
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    public final func stopMonitoring() {
        if isMonitoring, let monitor = monitor {
            monitor.cancel()
            self.monitor = nil
            isMonitoring = false
            didStopMonitoringHandler?()
        }
    }
}
