//
//  PostRequest.swift
//  Hit
//
//  Created by Pietro Putelli on 03/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import Foundation

class PostUrlRequest: NSMutableURLRequest {
    
    init(url: URL?, data: Data?) {
        super.init(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval())
        httpMethod = "POST"
        httpBody = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
