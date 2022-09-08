//
//  PhpLink.swift
//  Hit
//
//  Created by Pietro Putelli on 07/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

struct Php {
    
    struct User {
        static private let Domain = "https://www.finixinc.com/inside/php/user/"
        static private let ImageDomain = "https://www.finixinc.com/inside/usersData/"
        
        static let Suggested = Domain + "suggestedUsersGet.php"
        static let Search = Domain + "userSearch.php"
        
        static let GetUserByUsername = Domain + "getUserByUsername.php"
        static let GetUserById = Domain + "getUserById.php"
        
        static let Followers = Domain + "userFollowersGet.php"
        static let Following = Domain + "userFollowingGet.php"
        static let FollowersCount = Domain + "userFollowersCount.php"
        
        static let UploadImage = Domain + "userUploadImage.php"
        
        static let UsernameAvailability = Domain + "usernameAvailability.php"
        static let EditPassword = Domain + "userEditPassword.php"
        
        static let HandleFollow = Domain + "handleFollow.php"
        
        static let EditProfile = Domain + "editUserData.php"
        
        static let GetUsersLikedComment = Domain + "getUserLikedComment.php"
        
        static let GetRecentUsers = Domain + "getRecentUsers.php"
        static let GetFollowedByUsers = Domain + "getFollowedByUsers.php"
        static let GetFollowedByTitle = Domain + "getFollowedByTitle.php"
        
        static func profileImage(_ userId: Int) -> URL {
            return URL(string: "\(ImageDomain)\(userId)/profile.png")!
        }
        
        static func follower(_ type: FollowerType) -> String {
            guard type == .follower else {
                return Following
            }
            return Followers
        }
    }
    
    struct Chat {
        static private let Domain = "https://www.finixinc.com/inside/php/chats/"

        static let Get = Domain + "chatsGet.php"
        static let Search = Domain + "searchMyChat.php"
    }
    
    struct Comment {
        static private let Domain = "https://www.finixinc.com/inside/php/comments/"

        static let Create = Domain + "createComment.php"
        static let GetFollowing = Domain + "getFollowingComments.php"
        static let SetLike = Domain + "commentSetLike.php"
        static let SetFavourite = Domain + "commentSetFavourite.php"
        
        static let GetMyComments = Domain + "getMyComments.php"
        static let GetCommentsWhereIamTagged = Domain + "getCommentsWhereIamTagged.php"
    }
}
