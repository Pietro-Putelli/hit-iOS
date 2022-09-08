//
//  ShareSendButton.swift
//  Hit
//
//  Created by Pietro Putelli on 01/11/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ShareSendButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            let alpha: CGFloat = !isEnabled ? 0.5 : 1
            UIView.animate(withDuration: 0.2) {
                self.alpha = alpha
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Send".uppercased(), for: .normal)
        setFont(for: Fonts.Main)
        layer.addGradient(colors: UIColor.purpleGradient)
        roundCorner()
        alpha = 0.5
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

