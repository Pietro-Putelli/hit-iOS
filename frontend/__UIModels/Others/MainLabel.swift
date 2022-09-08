//
//  MainLabel.swift
//  searchBar
//
//  Created by Pietro Putelli on 28/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainLabel: UILabel {
    
    init(text: String? = nil, textColor: UIColor, fontSize: CGFloat, font: UIFont = Fonts.Main) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.textColor = textColor
        self.font = font.withSize(fontSize)
    }
    
    func fontSize(_ size: CGFloat) {
        self.font = font!.withSize(size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
