//
//  MainImageView.swift
//  Altriscatti
//
//  Created by Pietro Putelli on 25/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainImageView: UIImageView {
    
    init(contentMode: UIView.ContentMode = .scaleAspectFill) {
        super.init(frame: .zero)
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
    
    init(image: UIImage?, tintColor: UIColor) {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFill
        self.image = image
        self.tintColor = tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorner()
    }
}
