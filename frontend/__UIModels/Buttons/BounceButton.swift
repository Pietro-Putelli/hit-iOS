//
//  BounceButton.swift
//  searchBar
//
//  Created by Pietro Putelli on 13/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class BounceButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet{
            if isHighlighted {
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
                    self.transform = .identity
                }, completion: nil)
            }
        }
    }
}
