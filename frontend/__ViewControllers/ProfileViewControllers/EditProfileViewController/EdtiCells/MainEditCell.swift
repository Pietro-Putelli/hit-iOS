//
//  MainEditCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainEditCell: UICollectionViewCell {
    
    // MARK: - Models
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white(alpha: 0.6)
        label.font = Fonts.Main.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white(alpha: 0.8)
        tf.borderStyle = .none
        tf.font = Fonts.Main.withSize(18)
        tf.tintColor = .white
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var bottomLine: UIView = {
       let view = UIView()
        view.backgroundColor = .white(alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Proprieties
    
    private let bottomLineHeight: CGFloat = 0.5
    private let horizontalPadding: CGFloat = 18
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubviews(bottomLine, titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            bottomLine.heightAnchor.constraint(equalToConstant: bottomLineHeight),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding)
        ])
    }
    
    func setup(titleText: String, textFieldText: String?) {
        titleLabel.text = titleText.uppercased()
        textField.text = textFieldText
        textField.placeholder = titleText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
