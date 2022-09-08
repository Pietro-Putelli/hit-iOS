//
//  RecentSearchManager.swift
//  Hit
//
//  Created by Pietro Putelli on 31/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

class RecentSearchManager {
    
    private let maxUsers: Int = 4
    private let recentUserIdentifier: String = "recentUserIdentifier"
    private let userDefaults = UserDefaults.standard
    
    func add(_ userId: Int) {
        guard let recentUsers = userDefaults.value(forKey: recentUserIdentifier) as? String else {
            userDefaults.setValue("", forKey: recentUserIdentifier)
            return
        }
        var recentUsersArray = recentUsers.commaSeparatedToIntArray
        
        guard !recentUsersArray.contains(userId) else { return }
        
        recentUsersArray.insert(userId, at: 0)
        
        if recentUsersArray.count > maxUsers {
            recentUsersArray.removeLast()
        }
        userDefaults.setValue(recentUsersArray.commaSeparated, forKey: recentUserIdentifier)
    }
    
    func removeUser(_ userId: Int) {
        var userIds = retriveUserIds()
        guard let index = userIds.firstIndex(of: userId) else { return }
        userIds.remove(at: index)
        userDefaults.setValue(userIds.commaSeparated, forKey: recentUserIdentifier)
    }
    
    private func retriveUserIds() -> [Int] {
        guard let users = userDefaults.value(forKey: recentUserIdentifier) as? String else {
            return "".commaSeparatedToIntArray
        }
        return users.commaSeparatedToIntArray
    }
    
    func retriveUsers(completion: @escaping ([UserDB]) -> ()) {
        Database.User.getRecentUsers(userIds: retriveUserIds(), completion: completion)
    }
    
    func clear() {
        userDefaults.setValue("", forKey: recentUserIdentifier)
    }
}
