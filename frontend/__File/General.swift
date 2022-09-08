//
//  General.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

enum ScrollDirection: CGFloat {
    case left = -1
    case right = 1
    case up = 2
    case down = -2
    case no = -3
}

enum FollowerType: String {
    case follower = "Followers"
    case following = "Following"
}

struct Sample {
    static let Text200 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut a"
    static let Text240 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute"
    static let Text300 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillu"
}

struct CollectionView {
    struct Cells {
        static let SearchUser = "searchUser"
        static let SuggestedUser = "suggestesUser"
        static let Comment = "comment"
        static let Chat = "chat"
    }
    
    struct SupplementaryView {
        static let HeaderSpin = "headerSpin"
    }
}
