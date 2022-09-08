//
//  SearchBarExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 10/02/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    func setFont(for font: UIFont) {
        if let textField = value(forKey: "searchField") as? UITextField {
            textField.font = font
        }
    }
    
    func setTextColor(for color: UIColor) {
        if let textFieldInside = value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInside.leftView as? UIImageView {
            textFieldInside.textColor = color
            
            glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = color
        }
    }
    
    func setPlaceholderColor(for color: UIColor) {
        let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField
        if let textFieldInsideSearchBar1 = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel {
            textFieldInsideSearchBar1.textColor = color
        }
    }
    
    func setBackgroundColor(for color: UIColor) {
        if let textFieldInside = value(forKey: "searchField") as? UITextField {
            textFieldInside.backgroundColor = color
        }
    }
    
    func backgroundClear() {
        barTintColor = .clear
        backgroundColor = .clear
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
}
