//
//  _Comment.swift
//  Hit
//
//  Created by Pietro Putelli on 28/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension Database.CommentDb {
    
    class func createComment(comment: CreateComment, completion: @escaping (Bool) -> ()) {
        let url = URL(string: Php.Comment.Create)
        let request = PostUrlRequest(url: url, data: comment.json)
        Database.boolResponseCompletion(request: request, completion: completion)
    }
    
    class func getFollowingComments(offset: Int, completion: @escaping (([Comment]) -> ())) {
        let url = URL(string: Php.Comment.GetFollowing)
        let postParameter = "userId=\(User.shared.id)&offset=\(offset)"
        
        let request = PostUrlRequest(url: url, data: postParameter.utf8)
        commentsCompletion(request: request, completion: completion)
    }
    
    class func setCommentLike(commentId: Int, liked: Bool, completion: @escaping (Bool) -> ()) {
        let url = URL(string: Php.Comment.SetLike)
        let postParameters = "userId=\(User.shared.id)&commentId=\(commentId)&liked=\(liked.toInt)"
        
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        Database.boolResponseCompletion(request: request, completion: completion)
    }
    
    class func setCommentFavourite(commentId: Int, favorited: Bool, completion: @escaping (Bool) -> ()) {
        let url = URL(string: Php.Comment.SetFavourite)
        let postParameters = "userId=\(User.shared.id)&commentId=\(commentId)&favorited=\(favorited.toInt)"
        
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        Database.boolResponseCompletion(request: request, completion: completion)
    }
    
    class func getCommentWhereTagged(userId: Int, offset: Int, completion: @escaping ([Comment]) -> ()) {
        let url = URL(string: Php.Comment.GetCommentsWhereIamTagged)
        let postParameter = "myUserId=\(User.shared.id)&userId=\(userId)&offset=\(offset)"
        
        let request = PostUrlRequest(url: url, data: postParameter.utf8)
        commentsCompletion(request: request, completion: completion)
    }
    
    class func getUserComments(userId: Int, offset: Int, completion: @escaping ([Comment]) -> ()) {
        let url = URL(string: Php.Comment.GetMyComments)
        let postParameter = "myUserId=\(User.shared.id)&userId=\(userId)"
        
        let request = PostUrlRequest(url: url, data: postParameter.utf8)
        commentsCompletion(request: request, completion: completion)
    }
}
