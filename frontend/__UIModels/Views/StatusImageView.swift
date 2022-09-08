//
//  StatusImageView.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class StatusImageView: UIImageView {
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                setCheck()
            } else {
                setX()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    private func setCheck() {
        let image = UIImage(systemName: "checkmark.circle.fill")?.alwaysTemplate
        tintColor = .forestGreen
        setImage(image: image, pulse: true)
    }
    
    private func setX() {
        let image = UIImage(systemName: "xmark.circle.fill")?.alwaysTemplate
        tintColor = .flameRed
        setImage(image: image, pulse: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
