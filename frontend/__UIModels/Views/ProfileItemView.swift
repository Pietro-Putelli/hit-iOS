//
//  ProfileItemView.swift
//  Hit
//
//  Created by Pietro Putelli on 02/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ProfileItemView: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.roundCorner()
        imageView.image = UIImage(named: "steve")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
