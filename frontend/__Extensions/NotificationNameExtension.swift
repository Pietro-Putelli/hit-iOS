//
//  NotificationNameExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 17/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let reply = Notification.Name(rawValue: "reply")
    static let cancel = Notification.Name(rawValue: "cancel")
    static let goToReply = Notification.Name(rawValue: "goToReply")
    static let highlightReply = Notification.Name(rawValue: "highlightReply")
    static let quickReply = Notification.Name(rawValue: "quickReply")
    static let image = Notification.Name(rawValue: "image")
    static let imageTap = Notification.Name(rawValue: "imageTap")
    static let reloadCollectionView = Notification.Name(rawValue: "reloadCollectionView")
    static let stopActivityIndicator = Notification.Name(rawValue: "stopActivityIndicator")
    static let profileImage = Notification.Name(rawValue: "profileImage")
    static let refreshRecentSearch = Notification.Name(rawValue: "refreshRecentSearch")
    static let refreshHome = Notification.Name(rawValue: "refreshHome")
}
