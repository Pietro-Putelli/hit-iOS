//
//  UserDB.swift
//  searchBar
//
//  Created by Pietro Putelli on 28/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

struct UserDB: Codable {
    
    struct Identifiers {
        static let Id = "id"
        static let Username = "username"
        static let Name = "name"
        static let Bio = "bio"
        static let Link = "link"
        static let Instagram = "instagram"
        static let FollowBack = "followBack"
    }
    
    var id = Int()
    var username = String()
    var name = String()
    var bio = String()
    var link = String()
    var instagram = String()
    var followBack = Bool()
    
    init(id: Int, username: String, name: String, bio: String, link: String, instagram: String, followBack: Bool) {
        self.id = id
        self.username = username
        self.name = name
        self.bio = bio
        self.link = link
        self.instagram = instagram
        self.followBack = followBack
    }
    
    init(id: Int) {
        self.id = id
    }
}
