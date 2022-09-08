//
//  _Chat.swift
//  Hit
//
//  Created by Pietro Putelli on 07/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

extension Database.Chat {
    
    class func get(completion: @escaping ([Chat]) -> ()) {
        let url = URL(string: Php.Chat.Get)!
        let postParameter = "userId=\(User.shared.id)"
        let request = PostUrlRequest(url: url, data: postParameter.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data,_,_) in
            guard let data = data,
                let chats = try? JSONDecoder().decode([Chat].self, from: data) else { return }
            DispatchQueue.main.async {
                completion(chats)
            }
        }.resume()
    }
    
    class func searchMyChat(input: String, completion: @escaping ([Chat]) -> ()) {
        let url = URL(string: Php.Chat.Search)!
        let postParameters = "input=\(input)&userId=\(User.shared.id)"
        let request = PostUrlRequest(url: url, data: postParameters.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data,_,_) in
            guard let data = data,
                let chats = try? JSONDecoder().decode([Chat].self, from: data) else { return }
            DispatchQueue.main.async {
                completion(chats)
            }
        }.resume()
    }
}
