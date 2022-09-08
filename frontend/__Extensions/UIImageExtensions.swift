//
//  UIImageExtensions.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension UIImage {
    var alwaysTemplate: UIImage? {
        return withRenderingMode(.alwaysTemplate)
    }
    
    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        return self.withAlignmentRectInsets(insets).alwaysTemplate
    }
}

extension UIImage {
    func addGradient(colors: [UIColor]) -> UIImage? {
        
        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let locations: [CGFloat] = [0.0, 0.9]
        let colors = colors.cgColors() as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: width, y: height)
        
        bitmapContext!.clip(to: bounds, mask: maskImage!)
        bitmapContext!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        if let cImage = bitmapContext!.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            return coloredImage
        }
        return nil
    }
}

extension UIImage {
    func resize(for newSize: CGSize) -> UIImage {
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

extension UIImage {
    var toData: Data? {
        return pngData()
    }
}
