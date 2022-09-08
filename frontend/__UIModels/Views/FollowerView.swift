//
//  FollowerView.swift
//  searchBar
//
//  Created by Pietro Putelli on 03/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class FollowerView: UIView {
    
    // MARK: - Models
    
    lazy var countLabel: UILabel = {
       let label = UILabel()
        label.textColor = .perla
        label.font = Fonts.Main.withSize(20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white(alpha: 0.5)
        label.font = Fonts.Main.withSize(8)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tapGesture = UITapGestureRecognizer()
    
    private let horizontalInset: CGFloat = 2
    
    // MARK: - Proprieties
    
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
        addConstraints()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        
        addSubviews(countLabel,titleLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalInset),
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: horizontalInset),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -horizontalInset),
            
            titleLabel.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: -4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setTitles(count: Int, title: FollowerType) {
        tapGesture.isEnabled = count > 0
        countLabel.setText(count.roundedWithAbbreviations)
        titleLabel.text = title.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
