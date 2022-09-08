//
//  UIImageViewExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 22/04/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension UIImageView {
    func getPixelColor() -> UIColor {
        guard let image = image else { return .white }
        let pixelData = image.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(image.size.width) * Int(center.y)) + Int(center.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIImageView {
    func setImage(image: UIImage?, for transition: UIView.AnimationOptions = .transitionCrossDissolve, duration: TimeInterval = 0.2, pulse: Bool = false) {
        UIView.transition(with: self, duration: duration, options: transition, animations: {
            self.image = image
            if pulse {
                self.pulse()
            }
        }, completion: nil)
    }
}

extension UIImage {
    func resize(_ newSize: CGSize) -> UIImage {
        let widthRatio  = newSize.width  / size.width
        let heightRatio = newSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImageView {
    func crossDissolve(for image: UIImage?, duration: TimeInterval = 0.1) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
}
