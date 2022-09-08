//
//  User.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation
import UIKit

class User: Codable {
    
    struct Identifiers {
        static let Id = "id"
        static let Username = "username"
        static let Name = "name"
        static let Bio = "bio"
        static let Instagram = "instagram"
        static let Link = "link"
        static let ProfileImage = "profileImage"
    }
    
    enum UserType {
        case username
        case name
        case bio
        case instagram
        case link
    }
    
    static var shared: User {
        return retrive()
    }
    
    var profileImageSize = CGSize(side: 300)
    
    var id = Int()
    var username = String()
    var name = String()
    var bio = String()
    var instagram = String()
    var link = String()
    
    var imageData: Data? {
        set(image) {
            UserDefaults.standard.setValue(image?.toImage?.resize(profileImageSize).pngData(), forKey: Identifiers.ProfileImage)
        } get {
            guard let imageData = UserDefaults.standard.value(forKey: Identifiers.ProfileImage) as? Data else {
                return nil // placeholder
            }
            return imageData
        }
    }
    
    var json: Data? {
        let user = UserDB(id: id, username: username, name: name, bio: bio.replacingOccurrences(of: "'", with: "\\'"), link: link, instagram: instagram, followBack: false)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(user) else {
            return nil
        }
        return data
    }
    
    init(id: Int, username: String, name: String, bio: String, instagram: String, link: String) {
        self.id = id
        self.username = username
        self.name = name
        self.bio = bio
        self.instagram = instagram
        self.link = link
    }
    
    func set(_ value: String, type: UserType) {
        var identifier: String
        switch type {
        case .username:
            identifier = Identifiers.Username
        case .name:
            identifier = Identifiers.Name
        case .bio:
            identifier = Identifiers.Bio
        case .instagram:
            identifier = Identifiers.Instagram
        case .link:
            identifier = Identifiers.Link
        }
        UserDefaults.standard.setValue(value, forKey: identifier)
    }
    
    static private func retrive() -> User {
        let userDefaults = UserDefaults.standard
        
//        let user = User(id: 1, username: "PietroPutelli", name: "Pietro", bio: "Mi sono rotto le palle", instagram: "pietro_putelli", link: "www.finixinc.com")
//        UserDefaults.setUser(user)
        
        let id = userDefaults.value(forKey: Identifiers.Id) as! Int
        let username = userDefaults.value(forKey: Identifiers.Username) as! String
        let name = userDefaults.value(forKey: Identifiers.Name) as! String
        let bio = userDefaults.value(forKey: Identifiers.Bio) as? String
        let instagram = userDefaults.value(forKey: Identifiers.Instagram) as? String
        let link = userDefaults.value(forKey: Identifiers.Link) as? String
        
        return User(id: id, username: username, name: name, bio: bio ?? "", instagram: instagram ?? "", link: link ?? "")
    }
}

extension UserDefaults {
    
    static func setUser(_ user: User) {
        standard.setValue(user.id, forKey: User.Identifiers.Id)
        standard.setValue(user.username, forKey: User.Identifiers.Username)
        standard.setValue(user.name, forKey: User.Identifiers.Name)
        standard.setValue(user.bio, forKey: User.Identifiers.Bio)
        standard.setValue(user.instagram, forKey: User.Identifiers.Instagram)
        standard.setValue(user.link, forKey: User.Identifiers.Link)
    }
}

struct TemporaryUserSettings {
    static var username: String?
    static var name: String?
    static var bio: String?
    static var instagram: String?
    static var link: String?
    
    static func clear() {
        username = nil
        name = nil
        bio = nil
        instagram = nil
        link = nil
    }
}
