//
//  Comment.swift
//  Hit
//
//  Created by Pietro Putelli on 20/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

struct Comment: Codable, Hashable {
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int
    var userId: Int
    var username: String
    var content: String
    var date: String
    var liked: Bool
    var favourited: Bool
    var likedUsernames: String
    var likedByCount: Int
    var tagged_users: [Int]?
}

class CreateComment: Codable {
    
    var authorId: Int
    var content: String
    var taggedUsers: [String]
    var anonymous: Bool
    var date: String
    
    init(authorId: Int, content: String, taggedUsers: [String], anonymous: Bool, date: String) {
        self.authorId = authorId
        self.content = content
        self.taggedUsers = taggedUsers
        self.anonymous = anonymous
        self.date = date
    }
    
    var json: Data? {
        let comment = CreateComment(authorId: authorId, content: content.replacingOccurrences(of: "'", with: "\\'"), taggedUsers: taggedUsers, anonymous: anonymous, date: date)
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(comment) else {
            return nil
        }
        return data
    }
}
