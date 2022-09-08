//
//  IconMainEditCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 06/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class IconMainEditCell: MainEditCell {
    
    // MARK: - Models
    
    enum IconCellType {
        case instagram
        case link
        case password
    }
    
    lazy var imageView: UIImageView = {
       let imgView = UIImageView()
        imgView.tintColor = .electricIndigo
        return imgView
    }()
    
    lazy var rightChevron = ChevronView(type: .right, color: .white(alpha: 0.8))
    // MARK: - Proprieties
    
    var type: IconCellType?
    
    private let maxCharacters: Int = 128
    private let imageViewSize: CGSize = .init(width: 20, height: 20)
    private let rightChevronSize: CGSize = .init(width: 14, height: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(textField, imageView, rightChevron)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(type: IconCellType, textFieldText: String?) {
        self.type = type
        switch type {
        case .instagram:
            imageView.image = Images.Instagram
            titleLabel.text = "Instagram".uppercased()
            textField.autocorrectionType = .no
            textField.text = textFieldText ?? ""
        case .link:
            imageView.image = Images.SystemIcon.Link
            titleLabel.text = "Link".uppercased()
            textField.text = textFieldText ?? ""
            textField.autocorrectionType = .no
            textField.keyboardType = .URL
        case .password:
            imageView.image = Images.SystemIcon.Lock
            titleLabel.text = "Password".uppercased()
            textField.text = textFieldText ?? ""
            textField.isEnabled = false
            
            addSubview(rightChevron)
            
            rightChevron.anchorWidthHeight(size: rightChevronSize)
            NSLayoutConstraint.activate([
                rightChevron.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                rightChevron.trailingAnchor.constraint(equalTo: bottomLine.trailingAnchor, constant: -2)
            ])
        }
        addConstraints()
    }
    
    private func addConstraints() {
        imageView.anchorWidthHeight(size: imageViewSize)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: bottomLine.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: -4),
            
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            textField.trailingAnchor.constraint(equalTo: bottomLine.trailingAnchor)
        ])
    }
}

extension IconMainEditCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= maxCharacters
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        guard type == .link else {
            TemporaryUserSettings.instagram = text
            return
        }
        TemporaryUserSettings.link = text
    }
}
