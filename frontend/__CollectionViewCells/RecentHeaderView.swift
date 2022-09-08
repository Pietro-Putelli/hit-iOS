//
//  SearchUserCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 29/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class RecentHeaderView: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white(alpha: 0.6)
        label.font = Fonts.Main.withSize(12)
        label.text = "Recents"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
                
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
