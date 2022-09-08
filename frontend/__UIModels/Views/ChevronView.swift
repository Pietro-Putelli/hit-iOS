//
//  ChevronView.swift
//  Altriscatti
//
//  Created by Pietro Putelli on 25/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ChevronView: UIImageView {
    
    enum ChevronType: String {
        case right = "chevron.right"
        case left = "chevron.left"
        case down = "chevron.down"
        case up = "chevron.up"
    }
    
    let smallSize: CGSize = .init(width: 12, height: 16)
    
    init(type: ChevronType, color: UIColor) {
        super.init(frame: .zero)
        image = UIImage(systemName: type.rawValue, withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.alwaysTemplate
        contentMode = .scaleAspectFit
        tintColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
