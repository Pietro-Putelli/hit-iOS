//
//  File.swift
//  Hit
//
//  Created by Pietro Putelli on 06/01/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat) -> UIColor {
        return .init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }
    
    static func white(alpha: CGFloat) -> UIColor {
        return UIColor.white.withAlphaComponent(alpha)
    }
    
    static var perla: UIColor {
        return UIColor.rgb(255, 250, 250)
    }
    static var shiroi: UIColor {
        return UIColor.rgb(235, 240, 240)
    }
    static var perlaAlpha05: UIColor {
        return perla.withAlphaComponent(0.5)
    }
    
    static var maire: UIColor {
        return UIColor.rgb(10, 10, 10)
    }
    static var mardiGras: UIColor {
        return UIColor.rgb(20, 20, 20)
    }
    static var maireAlpha05: UIColor {
        return maire.withAlphaComponent(0.5)
    }
    
    // MARK: - Purple
    
    static var purple: UIColor {
        return .rgb(75,0,130)
    }
    
    static var electricIndigo: UIColor {
        return .rgb(111,0,255)
    }
    
    static var darkViolet: UIColor {
        return .rgb(148,0,211)
    }
    
    static var blueViolet: UIColor {
        return .rgb(138,43,226)
    }
    
    static var irisPurple: UIColor {
        return .rgb(106,90,205)
    }
    
    static var palaPurple: UIColor {
        return .rgb(177,156,217)
    }
    
    // MARK: - Blue
    
    static var royalBlue: UIColor {
        return .rgb(148,0,211)
    }
    
    static var cobaltBlue: UIColor {
        return .rgb(0,71,171)
    }
    
    // MARK: - Green
    
    static var tealGreen: UIColor {
        return rgb(0,128,128)
    }
    
    static var kellyGreen: UIColor {
        return rgb(76,187,23)
    }
    
    static var limeGreen: UIColor {
        return rgb(50,205,50)
    }
    
    static var forestGreen: UIColor {
        return rgb(34,139,34)
    }
    
    static var darkGreen: UIColor {
        return rgb(0,100,0)
    }
    
    static var britishRacingGreen: UIColor {
        return rgb(0,66,37)
    }
    
    // MARK: - Red
    
    static var venetianRed: UIColor {
        return rgb(200,8,21)
    }
    
    static var vermillionRed: UIColor {
        return rgb(227,66,52)
    }
    
    static var carnelianRed: UIColor {
        return rgb(179,27,27)
    }
    
    static var flameRed: UIColor {
        return rgb(207,53,46)
    }
    
    static var cinnabarRed: UIColor {
        return .rgb(228,77,46)
    }
    
    static var sanguineRed: UIColor {
        return .rgb(133,5,5)
    }
    
    static var rubyRed: UIColor {
        return .rgb(155,17,30)
    }
    
    // MARK: - Gradients
    
    static var purpleGradient: [UIColor] {
        return [.purple,.blueViolet]
    }
    
    static var purpleGradient2: [UIColor] {
        return [.purple,.irisPurple]
    }
    
    static var blueGradient: [UIColor] {
        return [.cobaltBlue,.tealGreen]
    }
    
    static var redGradient: [UIColor] {
        return [.sanguineRed,.cinnabarRed]
    }
    
    static var greenGradient: [UIColor] {
        return [.britishRacingGreen,.darkGreen]
    }
    
    static var maireGradient: [UIColor] {
        return [.maire,.clear]
    }
    
    static var tagColor: UIColor {
        return .blueViolet
    }
    
    static var whiteAlpha02: UIColor {
        return UIColor.white.withAlphaComponent(0.2)
    }
}


extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension Array where Element == UIColor {
    
    func cgColors() -> [CGColor] {
        var cgColors = [CGColor]()
        for color in self {
            cgColors.append(color.cgColor)
        }
        return cgColors
    }
}
