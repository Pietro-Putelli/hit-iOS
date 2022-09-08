//
//  MainSettingCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 13/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainSettingCell: MainBaseCell {
    
    // MARK: - Models
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white(alpha: 0.6)
        label.font = Fonts.Main.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.tintColor = .electricIndigo
        return imgView
    }()
    
    lazy var bottomLine: UIView = {
       let view = UIView()
        view.backgroundColor = .white(alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rightChevron = ChevronView(type: .right, color: .white(alpha: 0.8))
    
    // MARK: - Proprieties
    
    private let bottomLineHeight: CGFloat = 0.5
    private let horizontalPadding: CGFloat = 24
    
    private let iconSize: CGSize = .init(side: 25)
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(titleLabel,bottomLine,rightChevron,iconImageView)
        
        addConstraints()
    }
    
    private func addConstraints() {
        rightChevron.anchorWidthHeight(size: rightChevron.smallSize)
        iconImageView.anchorWidthHeight(size: iconSize)
        
        NSLayoutConstraint.activate([
            
            iconImageView.leadingAnchor.constraint(equalTo: bottomLine.leadingAnchor, constant: 8),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            bottomLine.heightAnchor.constraint(equalToConstant: bottomLineHeight),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            
            rightChevron.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            rightChevron.trailingAnchor.constraint(equalTo: bottomLine.trailingAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
