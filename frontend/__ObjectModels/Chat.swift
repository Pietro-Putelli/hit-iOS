//
//  Message.swift
//  Hit
//
//  Created by Pietro Putelli on 04/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class Chat: Decodable {
    
    var id = Int()
    var senderId = Int()
    var receiverId = Int()
    var username = String()
    var imageData: Data?
    
    init(id: Int, senderId: Int, receiverId: Int, username: String) {
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.username = username
    }
}
