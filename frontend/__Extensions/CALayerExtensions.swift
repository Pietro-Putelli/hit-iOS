//
//  CALayerExtensions.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addGradient(size: CGSize? = nil, colors: [UIColor], locations: [NSNumber] = [0.0, 0.8], startPoint: CGPoint = .init(x: 0, y: 1), endPoint: CGPoint = .init(x: 1, y: 1)) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = (size == nil) ? bounds : .init(origin: .zero, size: size!)
        gradientLayer.colors = colors.cgColors()
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        insertSublayer(gradientLayer, at: 0)
    }
}

extension CALayer {
    
    func addBorder(bounds: CGRect, lineWidth: CGFloat, gradientColors: [UIColor], locations: [NSNumber] = []) {
        let gradient = CAGradientLayer()
        gradient.frame = .init(origin: .zero, size: bounds.size)
        gradient.colors = gradientColors.cgColors()
        gradient.locations = [0.2,0.8]
        gradient.startPoint = .init(x: 0, y: 1)
        gradient.endPoint = .init(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        
        let roundedRectFrame: CGRect = .init(x: bounds.origin.x + lineWidth / 2, y: bounds.origin.y + lineWidth / 2, width: bounds.width - lineWidth, height: bounds.height - lineWidth)
        shape.path = UIBezierPath(roundedRect: roundedRectFrame, cornerRadius: bounds.width / 2).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        addSublayer(gradient)
    }
}
