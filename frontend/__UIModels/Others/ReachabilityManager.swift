//
//  ReachabilityManager.swift
//  searchBar
//
//  Created by Pietro Putelli on 14/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()

    var reachabilityStatus: Reachability.Connection = .unavailable

    var isNetworkAvailable: Bool {
        return reachabilityStatus != .unavailable
    }

    let reachability = try! Reachability()

    @objc private func reachabilityChanged(_ notification: Notification) {
        let reachability = notification.object as! Reachability

        switch reachability.connection {
        case .unavailable, .none: NotificationCenter.default.post(name: .reachabilityChanged, object: nil, userInfo: [Notification.Name.reachabilityChanged.rawValue : false])
        case .wifi, .cellular: NotificationCenter.default.post(name: .reachabilityChanged, object: nil, userInfo: [Notification.Name.reachabilityChanged.rawValue : true])
        }
    }

    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("error")
        }
    }

    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}
