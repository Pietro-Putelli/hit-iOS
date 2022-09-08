//
//  Database.swift
//  searchBar
//
//  Created by Pietro Putelli on 28/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class Database {
    
    static let Limit: Int = 4
    
    class User {
        class func usersCompletion(request: PostUrlRequest, completion: @escaping ([UserDB]) -> ()) {
            URLSession.shared.dataTask(with: request as URLRequest) {
                (data,_, error) in
                
                guard let data = data else { return }
                do {
                    let users = try JSONDecoder().decode([UserDB].self, from: data)
                    DispatchQueue.main.async {
                        completion(users)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                    }
                    print(error.localizedDescription)
                }
            }.resume()
        }
        
        class func userCompletion(request: PostUrlRequest, completion: @escaping (UserDB) -> ()) {
            URLSession.shared.dataTask(with: request as URLRequest) {
                (data,_, error) in
                
                guard let data = data else { return }
                do {
                    let users = try JSONDecoder().decode(UserDB.self, from: data)
                    DispatchQueue.main.async {
                        completion(users)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
    
    class Chat { }
    
    class CommentDb {
        class func commentsCompletion(request: PostUrlRequest, completion: @escaping ([Comment]) -> ()) {
            URLSession.shared.dataTask(with: request as URLRequest) {
                
                (data,_,error) in
                guard let data = data else { return }
                do {
                    let comments = try JSONDecoder().decode([Comment].self, from: data)
                    DispatchQueue.main.async {
                        completion(comments)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
    
    class Image { }
}

extension Database {
    class func boolResponseCompletion(request: PostUrlRequest, completion: @escaping (Bool) -> ()) {
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data,_,error) in
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Bool],
                  let response = json["response"] else { return }
            DispatchQueue.main.async {
                completion(response)
            }
        }.resume()
    }
}
