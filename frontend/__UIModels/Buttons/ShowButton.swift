//
//  ShowButton.swift
//  searchBar
//
//  Created by Pietro Putelli on 12/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ShowButton: UIButton {

    var isShown: Bool = false {
        didSet {
            if isShown {
                shown()
            } else {
                hidden()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        hidden()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func shown() {
        tintColor = .white(alpha: 0.4)
        setImage(Images.SystemIcon.Eye.Show, for: .normal)
    }
    
    private func hidden() {
        tintColor = .white(alpha: 0.4)
        setImage(Images.SystemIcon.Eye.Hide, for: .normal)
    }
}
