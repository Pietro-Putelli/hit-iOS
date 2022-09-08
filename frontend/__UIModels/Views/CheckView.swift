//
//  CheckView.swift
//  Hit
//
//  Created by Pietro Putelli on 01/11/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class CheckView: UIImageView {
    
    var isChecked: Bool = false {
        didSet {
            let image = isChecked ? Images.SystemIcon.Circles.SmallCircleFill : Images.SystemIcon.Circles.CircleEmpty
            pulse { [weak self] in
                self?.setImage(image: image)
            }
        }
    }
    
    private let duration: TimeInterval = 0.2
    
    init() {
        super.init(frame: .zero)
        
        image = Images.SystemIcon.Circles.CircleEmpty
        tintColor = .electricIndigo
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
