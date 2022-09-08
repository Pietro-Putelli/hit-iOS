//
//  UIViewExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 31/03/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension UIView {
    func generateHapticFeedback(for style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    func pulse(hapticFeedback: Bool = false, animationDuration: TimeInterval = 0.15, scaleBy: CGFloat = 0.95, completion: (() -> Void)? = nil) {
        if hapticFeedback {
            generateHapticFeedback(for: .light)
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.transform = CGAffineTransform(scaleX: scaleBy, y: scaleBy)
        }) { (_) in
            UIView.animate(withDuration: animationDuration, animations: {
                self.transform = .identity
                completion?()
            })
        }
    }
}

extension UIView {

    func fadeIn(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!, animations: {
            self.alpha = 1
        }, completion: { (value: Bool) in
            if let complete = onCompletion {
                complete()
            }
        })
    }

    func fadeOut(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: {
                        self.alpha = 0
        }, completion: { (value: Bool) in
            self.isHidden = true
            if let complete = onCompletion {
                complete()
            }
        })
    }
}

extension UIView {
    func roundCorner(radius: CGFloat? = nil) {
        layer.cornerRadius = (radius == nil) ? bounds.height / 2 : radius!
        layer.masksToBounds = false
        clipsToBounds = true
    }
    
    func makeBorderPath(forBorderWidth: CGFloat, color: UIColor) {
        layer.borderWidth = forBorderWidth
        layer.borderColor = color.cgColor
    }
    
    func roundCorners2(corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
     func addTopBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }
    
    func addBottomBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.height, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }
}

extension UIView {
    func removeBorder() {
        layer.borderWidth = 0.0
    }
}

extension UIView {
    func animateColorChange(for color: UIColor, duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration) {
            self.backgroundColor = color
        }
    }
}

extension UIScrollView {
    func setContentOffSet(x: CGFloat, direction: ScrollDirection) {
        setContentOffset(CGPoint(x: contentOffset.x + direction.rawValue * x, y: 0.0), animated: true)
    }
    
    func setContentOffSetAnimate(for x: CGFloat, direction: ScrollDirection?, animationDuration: TimeInterval = 0.2) {
        guard let direction = direction else {
            return
        }
        UIView.animate(withDuration: animationDuration) {
            self.contentOffset.x += direction.rawValue * x
        }
    }
}

extension UIView {
    func dropShadow(radius: CGFloat = 4, opacity: Float = 0.5, color: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .init(width: 0, height: 1)
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
    }
}

extension UIView {
    func roundCorners(corners: CACornerMask, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
    }
    
    func roundBottomCorners(cornerRadius: CGFloat) {
        roundCorners(corners: [.layerMinXMaxYCorner,.layerMaxXMaxYCorner], cornerRadius: cornerRadius)
    }
    
    func roundTopCorners(cornerRadius: CGFloat) {
        roundCorners(corners: [.layerMinXMinYCorner,.layerMaxXMinYCorner], cornerRadius: cornerRadius)
    }
}

extension UIView {
    func addGestureRecognizers(_ gestures: UIGestureRecognizer...) {
        for gesture in gestures {
            addGestureRecognizer(gesture)
        }
    }
    
    func addGestureRecognizers(_ gestures: [UIGestureRecognizer]) {
        for gesture in gestures {
            addGestureRecognizer(gesture)
        }
    }
}
extension UIView {
    func bounce(animationDuration: TimeInterval = 0.3) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [0.9,0.95, 1.05, 1.0]
        bounceAnimation.duration = animationDuration
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        layer.add(bounceAnimation, forKey: nil)
    }
}

extension UIView {
    func hide(_ hidden: Bool, animationDuration: TimeInterval = 0.4) {
        UIView.transition(with: self, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    }
}

extension UIView {
    func addIfNotAlreadyIt(_ view: UIView) {
        if !view.isDescendant(of: self) {
            addSubview(view)
        }
    }
}
