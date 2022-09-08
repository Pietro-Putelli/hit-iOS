//
//  MainSearchBar.swift
//  Hit
//
//  Created by Pietro Putelli on 04/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainSearchBar: UITextField {
    
    private let padding: UIEdgeInsets = .init(horizontal: 4, vertical: 0)
    
    init(frame: CGRect = .zero, constraints: Bool = true) {
        super.init(frame: frame)
        
        borderStyle = .none
        font = Fonts.Main.withSize(16)
        clearButtonMode = .whileEditing
        placeholder = "Search"
        textColor = .white(alpha: 0.8)
        tintColor = .purple
        translatesAutoresizingMaskIntoConstraints = !constraints
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func fontSize(_ size: CGFloat) {
        self.font = font!.withSize(size)
    }
    
    func addBottomBorder() {
        addBottomBorder(color: .white(alpha: 0.1), width: 0.5)
    }
    
    func hideKeyboard(_ hidden: Bool) {
        if hidden {
            resignFirstResponder()
        } else {
            becomeFirstResponder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
