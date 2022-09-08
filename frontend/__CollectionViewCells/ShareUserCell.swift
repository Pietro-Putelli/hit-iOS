//
//  ShareUserCell.swift
//  Hit
//
//  Created by Pietro Putelli on 31/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ShareUserCell: SearchUserCell {
    
    let checkView = CheckView()
    
    var isSelect: Bool = false {
        didSet {
            checkView.isChecked = isSelect
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        deleteButton.removeFromSuperview()
        rightChevron.removeFromSuperview()
        addSubview(checkView)
        
        backgroundColor = .maire
        
        checkView.anchorWidthHeight(size: .init(side: frame.height * 0.4))
        NSLayoutConstraint.activate([
            checkView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            checkView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
