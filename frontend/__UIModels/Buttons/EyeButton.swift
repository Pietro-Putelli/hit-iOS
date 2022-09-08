//
//  EyeButton.swift
//  Hit
//
//  Created by Pietro Putelli on 03/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class AnonymousButton: UIButton {
    
    var isShown: Bool = false {
        didSet {
            if isShown {
                showed()
            } else {
                hidden()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.addGradient(colors: UIColor.purpleGradient)
        roundCorner()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showed() {
        tintColor = .white(alpha: 0.8)
        setImage(image: Images.Eye.Show)
        pulse(hapticFeedback: true)
    }
    
    private func hidden() {
        tintColor = .white(alpha: 0.8)
        setImage(image: Images.Eye.Hide)
        pulse(hapticFeedback: true)
    }
}
