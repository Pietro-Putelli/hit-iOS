//
//  LogOutCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 13/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class LogOutCell: UICollectionViewCell {
    
    // MARK: - Models
    
    lazy var button: BounceButton = {
       let button = BounceButton()
        button.setTitle("Log Out".uppercased(), for: .normal)
        button.setTitleColor(.flameRed, for: .normal)
        button.titleLabel?.font = Fonts.Main.withSize(16)
        button.addTarget(self, action: #selector(logOut(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Proprieties
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func logOut(_ sender: UIButton) {
        delegate?.logOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
