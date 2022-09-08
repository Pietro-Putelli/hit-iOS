//
//  ShareButton.swift
//  Hit
//
//  Created by Pietro Putelli on 30/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ShareButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        tintColor = .white
        imageEdgeInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
        setImage(Images.Paperplane, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
