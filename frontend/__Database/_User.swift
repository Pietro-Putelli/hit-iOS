//
//  _User.swift
//  Hit
//
//  Created by Pietro Putelli on 03/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

extension Database.User {
    
    class func searchUsers(input: String, offset: Int, completion: @escaping ([UserDB]) -> ()) {
        let requestUrl = URL(string: Php.User.Search)
        let postParameters = "user_id=\(User.shared.id)&input=\(input)&offset=\(offset)"
        let request = PostUrlRequest(url: requestUrl!, data: postParameters.utf8)
        usersCompletion(request: request, completion: completion)
    }
    
    class func getSuggestedUsers(limit: Int, offset: Int, completion: @escaping ([UserDB])->()) {
        let url = URL(string: Php.User.Suggested)
        let postParameters = "user_id=\(User.shared.id)&limit=\(limit)&offset=\(offset)"
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        usersCompletion(request: request, completion: completion)
    }
    
    class func getFollowers(userId: Int, type: FollowerType, offset: Int, completion: @escaping ([UserDB]) -> ()) {
        let url = URL(string: Php.User.follower(type))
        let postParameters = "mainUserId=\(User.shared.id)&userId=\(userId)&offset=\(offset)"
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        usersCompletion(request: request, completion: completion)
    }
    
    class func getUsernameAvailability(username: String, completion: @escaping (Bool) -> ()) {
        let url = URL(string: Php.User.UsernameAvailability)
        let postParameters = "user_id=\(User.shared.id)&username=\(username)"
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        Database.boolResponseCompletion(request: request, completion: completion)
    }
    
    class func editUserData(completion: @escaping (Bool) -> ()) {
        let url = URL(string: Php.User.EditProfile)
        let request = PostUrlRequest(url: url, data: User.shared.json)
        Database.boolResponseCompletion(request: request, completion: completion)
    }
    
    class func editPassword(oldPassword: String, newPassword: String, _ completion: @escaping (Bool) -> ()) {
        let url = URL(string: Php.User.EditPassword)
        let postParameters = "oldPassword=\(oldPassword)&newPassword=\(newPassword)&userId=\(User.shared.id)"
        
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        Database.boolResponseCompletion(request: request, completion: completion)
    }
    
    class func getUserBy(username: String, completion: @escaping (UserDB?) -> ()) {
        let url = URL(string: Php.User.GetUserByUsername)
        let postParameters = "userId=\(User.shared.id)&username=\(username)"
        
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        userCompletion(request: request, completion: completion)
    }
    
    class func getUserBy(userId: Int, completion: @escaping (UserDB?) -> ()) {
        let url = URL(string: Php.User.GetUserById)
        let postParameters = "myUserId=\(User.shared.id)&userId=\(userId)"
        
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        userCompletion(request: request, completion: completion)
    }
    
    class func handleFollow(followingId: Int, isFollowing: Bool, completion: @escaping (Bool) -> ()) {
        let url = URL(string: Php.User.HandleFollow)
        let postParamerers = "userId=\(User.shared.id)&followingId=\(followingId)&follow=\(isFollowing.toInt)"
        
        let request = PostUrlRequest(url: url, data: postParamerers.utf8)
        Database.boolResponseCompletion(request: request, completion: completion)
    }
    
    class func getUsersLikedComment(commentId: Int, offset: Int, completion: @escaping ([UserDB]) -> ()) {
        let url = URL(string: Php.User.GetUsersLikedComment)
        let postParameters = "userId=\(User.shared.id)&commentId=\(commentId)&offset=\(offset)"
        
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        usersCompletion(request: request, completion: completion)
    }
    
    class func getRecentUsers(userIds: [Int], completion: @escaping ([UserDB]) -> ()) {
        let url = URL(string: Php.User.GetRecentUsers)
        let postParameter = "myUserId=\(User.shared.id)&userIds=\(userIds.commaSeparated)"
        
        let request = PostUrlRequest(url: url, data: postParameter.utf8)
        usersCompletion(request: request, completion: completion)
    }
    
    class func getFollowedByUsers(userId: Int, offset: Int, completion: @escaping ([UserDB]) -> ()) {
        let url = URL(string: Php.User.GetFollowedByUsers)
        let postParameters = "myUserId=\(User.shared.id)&userId=\(userId)&offset=\(offset)"
        
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        usersCompletion(request: request, completion: completion)
    }
    
    class func getFollowersCount(userId: Int, completion: @escaping ((Int,Int) -> ())) {
        let url = URL(string: Php.User.FollowersCount)
        let postParameter = "user_id=\(userId)"
        let request = PostUrlRequest(url: url, data: postParameter.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data,_,error) in
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Int]
            else { return }
            DispatchQueue.main.async {
                completion(json["followers"]!,json["following"]!)
            }
        }.resume()
    }
    
    class func getFollowedByTitle(userId: Int, completion: @escaping (([String],Int)) -> ()) {
        let url = URL(string: Php.User.GetFollowedByTitle)
        let postParameters = "myUserId=\(User.shared.id)&userId=\(userId)"
        
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data,_,error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject],
                  let usernames = json["usernames"] as? [String],
                  let counting = json["counting"] as? Int
            else { return }
            DispatchQueue.main.async {
                completion((usernames,counting))
            }
        }.resume()
    }
}
