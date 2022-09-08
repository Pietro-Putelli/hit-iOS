//
//  SearchBarView.swift
//  searchBar
//
//  Created by Pietro Putelli on 26/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class SearchBarView: BounceView {
    
    // MARK: - Models
    
    lazy var searchImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .white(alpha: 0.8)
        return imgView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Everything"
        label.textColor = .perla
        label.font = Fonts.Main.withSize(18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Proprieties
        
    init(image: UIImage?, padding: CGFloat = 0) {
        super.init(image: image, padding: padding)
        
        setupSubviews()
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup functions
    
    private func setupSubviews() {
        addSubviews(searchImageView,titleLabel)
        
        backgroundColor = .mardiGras
        dropShadow(color: .maire)
    }
    
    private func addConstraints() {
        let x: CGFloat = 25
        
        searchImageView.anchorWidthHeight(size: .init(width: x, height: x))
        titleLabel.centerSuperview()
        
        NSLayoutConstraint.activate([
            searchImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
