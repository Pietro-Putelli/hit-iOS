//
//  UIButtonExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 22/04/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension UIButton {
    func rotateImageView(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5) {
            self.imageView?.transform = transform
        }
    }
}

extension UIBarButtonItem {
    func setButtonFontText(for font: UIFont) {
        setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.font: font], for: .highlighted)
    }
}

extension UIButton {
    func setFont(for font: UIFont) {
        titleLabel?.font = font
    }
}

extension UIButton {
    func shadeAnimation(withDuration duration: TimeInterval, image: UIImage) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: duration) {
                self.alpha = 1
                self.setImage(image, for: .normal)
            }
        }
    }
    
    func shadeBackgroundAnimation(withDuration duration: TimeInterval, image: UIImage?) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: duration) {
                self.alpha = 1
                self.setBackgroundImage(image, for: .normal)
            }
        }
    }
    
    func shadeBackground(withDuration duration: TimeInterval, color: UIColor) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: duration) {
                self.alpha = 1
                self.backgroundColor = color
            }
        }
    }
}

extension UIButton {
    func setColor(backgroundColor: UIColor, titleColor: UIColor, borderColor: UIColor) {
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        layer.borderColor = borderColor.cgColor
    }
}

extension UIButton {
    func setImage(image: UIImage?, for transition: UIView.AnimationOptions = .transitionCrossDissolve, duration: TimeInterval = 0.2, pulse: Bool = false) {
        UIView.transition(with: self, duration: duration, options: transition, animations: {
            self.setImage(image, for: .normal)
            if pulse {
                self.pulse()
            }
        }, completion: nil)
    }
}

extension UIButton {
    func titleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
    }
}

