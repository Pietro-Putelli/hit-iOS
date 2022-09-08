//
//  Images.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

struct Images {
    
    static let contentConfiguration = UIImage.SymbolConfiguration(weight: .thin)
    
    struct SystemIcon {
        static let XMark = UIImage(systemName: "xmark", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let CameraRotate = UIImage(systemName: "camera.rotate", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let Flash = UIImage(systemName: "bolt.slash", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let More = UIImage(systemName: "ellipsis", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let Brush = UIImage(systemName: "paintbrush", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let Notification = UIImage(systemName: "bell", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let Chat = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let Info = UIImage(systemName: "info", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let CheckMarkCircle = UIImage(systemName: "checkmark.circle.fill", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let CheckMark = UIImage(systemName: "checkmark", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let Link = UIImage(systemName: "link", withConfiguration: contentConfiguration)!.alwaysTemplate
        static let Lock = UIImage(systemName: "lock", withConfiguration: contentConfiguration)!.alwaysTemplate
        
        struct Circles {
            static let CircleEmpty = UIImage(systemName: "circle", withConfiguration: contentConfiguration)!.alwaysTemplate
            static let SmallCircleFill = UIImage(systemName: "largecircle.fill.circle", withConfiguration: contentConfiguration)!.alwaysTemplate
        }
        
        struct Eye {
            static let Show = UIImage(systemName: "eye", withConfiguration: contentConfiguration)!.alwaysTemplate
            static let Hide = UIImage(systemName: "eye.slash", withConfiguration: contentConfiguration)!.alwaysTemplate
        }
        
        struct Chevrons {
            static let Left = UIImage(systemName: "chevron.left", withConfiguration: contentConfiguration)!.alwaysTemplate
            static let Down = UIImage(systemName: "chevron.down", withConfiguration: contentConfiguration)!.alwaysTemplate
            static let Right = UIImage(systemName: "chevron.right", withConfiguration: contentConfiguration)!.alwaysTemplate
            static let Up = UIImage(systemName: "chevron.up", withConfiguration: contentConfiguration)!.alwaysTemplate
        }
    }
    
    struct TabBar {
        static let HomeEmpty = UIImage(named: "home.empty")?.alwaysTemplate
        static let HomeFill = UIImage(named: "home.fill")?.alwaysTemplate
        
        static let Plus = UIImage(named: "plus.circle")?.alwaysTemplate
        
        static let ProfileEmpty = UIImage(named: "profile.empty")?.alwaysTemplate
        static let ProfileFill = UIImage(named: "profile.fill")?.alwaysTemplate
        
        static let Empty = [HomeEmpty,Plus,ProfileEmpty]
        static let Fill = [HomeFill,Plus,ProfileFill]
    }
    
    static let Gear = UIImage(named: "gear")?.alwaysTemplate
    static let Paperplane = UIImage(named: "paperplane")?.alwaysTemplate
    static let Paperplane1 = UIImage(named: "paperplane-1")?.alwaysTemplate
    static let SearchGlass = UIImage(named: "search")?.alwaysTemplate
    static let Network = UIImage(named: "network")?.alwaysTemplate
    static let Snail = UIImage(named: "snail")?.alwaysTemplate
    static let Notification = UIImage(named: "notification")?.alwaysTemplate
    static let Info = UIImage(named: "info")?.alwaysTemplate
    static let Edit = UIImage(named: "edit")?.alwaysTemplate
    static let Plus = UIImage(named: "plus")?.alwaysTemplate
    static let Filter = UIImage(named: "filter")?.alwaysTemplate
    static let More = UIImage(named: "more")?.alwaysTemplate
    static let Instagram = UIImage(named: "instagram")?.alwaysTemplate
    
    struct Eye {
        static let Show = UIImage(named: "eye")?.alwaysTemplate
        static let Hide = UIImage(named: "eye.slash")?.alwaysTemplate
    }
    
    struct BookMark {
        static let Empty = UIImage(named: "bookmark.empty")?.withRenderingMode(.alwaysTemplate)
        static let Fill = UIImage(named: "bookmark.fill")?.withRenderingMode(.alwaysTemplate)
    }
    
    static let Steve = UIImage(named: "steve")
    static let Elon = UIImage(named: "elon")
}
