//
//  SearchBarButton.swift
//  searchBar
//
//  Created by Pietro Putelli on 26/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class SearchBarButton: UIButton {
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        let image = UIImage(named: "search")
        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .init(top: 0, left: -30, bottom: 0, right: 0)
        
        setTitle("Search", for: .normal)
        titleLabel?.font = Fonts.Main.withSize(18)
        titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
