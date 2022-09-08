//
//  UsernameCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class UsernameEditCell: MainEditCell {
    
    // MARK: - Models
    
    lazy var statusImageView = StatusImageView()
    
    lazy var snailImageView: UIImageView = {
       let imgView = UIImageView()
        imgView.image = UIImage(named: "snail")?.alwaysTemplate
        imgView.tintColor = .electricIndigo
        return imgView
    }()
    
    // MARK: - Proprieties
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    private let maxUsernameCharacters: Int = 32
    private let statusSize: CGSize = .init(width: 20, height: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFiledDidChange(_:)), for: .editingChanged)
        textField.autocorrectionType = .no
        
        addSubviews(textField, statusImageView, snailImageView)
        addConstraints()
    }
    
    override func setup(titleText: String, textFieldText: String?) {
        super.setup(titleText: titleText, textFieldText: textFieldText)
    }
    
    private func addConstraints() {
        statusImageView.anchorWidthHeight(size: statusSize)
        snailImageView.anchorWidthHeight(size: statusSize)
        
        NSLayoutConstraint.activate([
            
            snailImageView.leadingAnchor.constraint(equalTo: bottomLine.leadingAnchor),
            snailImageView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: -4),
            
            textField.leadingAnchor.constraint(equalTo: snailImageView.trailingAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            textField.trailingAnchor.constraint(equalTo: statusImageView.leadingAnchor, constant: -16),
            
            statusImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            statusImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Handle UITextField

extension UsernameEditCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= maxUsernameCharacters && string != .whiteSpace
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.enableDoneButton?(false)
        return true
    }
    
    @objc private func textFiledDidChange(_ textField: UITextField) {
        guard let text = textField.text, text != "" && text.isValidUsername else {
            delegate?.enableDoneButton?(false)
            statusImageView.isChecked = false
            return
        }
        
        Database.User.getUsernameAvailability(username: text) { [weak self] (enabled) in
            self?.statusImageView.isChecked = enabled
            self?.delegate?.enableDoneButton?(enabled)
            
            if enabled {
                TemporaryUserSettings.username = text
            }
        }
    }
}
