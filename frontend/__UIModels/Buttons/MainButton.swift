//
//  MainButton.swift
//  searchBar
//
//  Created by Pietro Putelli on 03/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainButton: UIButton {
    
    // MARK: - Proprieties
    
    var size: CGSize!
    
    var isFill: Bool = false {
        didSet {
            if isFill {
                fill()
            } else {
                empty()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            let alpha: CGFloat = !isEnabled ? 0.5 : 1
            UIView.animate(withDuration: 0.2) {
                self.alpha = alpha
            }
        }
    }
    
    init(size: CGSize) {
        super.init(frame: .init(origin: .zero, size: size))
        
        self.size = size
        fill()
        roundCorner(radius: size.height / 2)
        
        titleLabel?.font = Fonts.Main.withSize(14)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func fill() {
        layer.addGradient(size: size, colors: UIColor.purpleGradient)
        setTitleColor(.perla, for: .normal)
        removeBorder()
    }
    
    func empty() {
        backgroundColor = .mardiGras
        makeBorderPath(forBorderWidth: 1.0, color: .white(alpha: 0.2))
        layer.sublayers?.removeFirst()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
