//
//  PasswordEditCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 12/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class PasswordEditCell: MainEditCell {
    
    // MARK: - Models
    
    lazy var statusImageView = StatusImageView()
    
    lazy var showButton: ShowButton = {
        let button = ShowButton()
        button.addTarget(self, action: #selector(showButton(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Proprieties
    
    weak var passwordEditViewControllerDelegate: PasswordEditViewControllerDelegate?
    
    private let maxPasswordCharactersCount: Int = 32
    private let statusSize: CGSize = .init(width: 20, height: 20)
    private let showButtonSize: CGSize = .init(width: 25, height: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFiledDidChange(_:)), for: .editingChanged)
        
        addSubviews(textField, statusImageView, showButton)
        addConstraints()
    }
    
    override func setup(titleText: String, textFieldText: String?) {
        super.setup(titleText: titleText, textFieldText: textFieldText)
    }
    
    private func addConstraints() {
        statusImageView.anchorWidthHeight(size: statusSize)
        showButton.anchorWidthHeight(size: showButtonSize)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: bottomLine.leadingAnchor, constant: 2),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            textField.trailingAnchor.constraint(equalTo: statusImageView.leadingAnchor, constant: -16),
            
            showButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            showButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            statusImageView.trailingAnchor.constraint(equalTo: showButton.leadingAnchor, constant: -8),
            statusImageView.bottomAnchor.constraint(equalTo: showButton.bottomAnchor)
        ])
    }
    
    @objc private func showButton(_ sender: UIButton) {
        showButton.isShown = !showButton.isShown
        textField.isSecureTextEntry = showButton.isShown
        showButton.pulse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PasswordEditCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count < maxPasswordCharactersCount
    }
    
    @objc private func textFiledDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let enabled = !text.isEmptyTrimmingSpaces && !text.containsSpaces && text.count > 8
        statusImageView.isChecked = enabled
        
        let checkType: PasswordEditViewController.CheckType = tag == 1 ? .oldPassword : .newPassword
        passwordEditViewControllerDelegate?.enableCheckButton(checkType, enabled, textField)
    }
}
