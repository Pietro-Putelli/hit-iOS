//
//  UILabelExtensions.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension UILabel {
    func fadeTransition() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .fade
        animation.duration = 0.3
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UILabel {
    func setFirstCharacterColor(_ color: UIColor) {
        let range = NSRange(location: 0, length: 1)
        let attributedString = NSMutableAttributedString(string: text!, attributes: [NSAttributedString.Key.font : font!])
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}

extension UILabel {
    func setText(_ text: String?) {
        UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.text = text
        }, completion: nil)
    }
}
