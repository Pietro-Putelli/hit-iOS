//
//  NameEditCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 06/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class NameEditCell: MainEditCell {
    
    // MARK: - Proprieties
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    private let maxUsernameCharacters: Int = 32
    private let statusSize: CGSize = .init(width: 20, height: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFiledDidChange(_:)), for: .editingChanged)
        textField.autocorrectionType = .no
        
        addSubviews(textField)
        addConstraints()
    }
    
    override func setup(titleText: String, textFieldText: String?) {
        super.setup(titleText: titleText, textFieldText: textFieldText)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: bottomLine.leadingAnchor, constant: 2),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NameEditCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= maxUsernameCharacters
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.enableDoneButton?(false)
        return true
    }
    
    @objc private func textFiledDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmptyTrimmingSpaces else {
            delegate?.enableDoneButton?(false)
            return
        }
        delegate?.enableDoneButton?(true)
        TemporaryUserSettings.name = text
    }
}
