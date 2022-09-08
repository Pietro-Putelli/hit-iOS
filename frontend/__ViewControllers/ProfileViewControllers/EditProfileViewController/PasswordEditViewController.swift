//
//  PasswordEditViewController.swift
//  searchBar
//
//  Created by Pietro Putelli on 06/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

protocol PasswordEditViewControllerDelegate: class {
    func enableCheckButton(_ checkType: PasswordEditViewController.CheckType, _ enabled: Bool, _ textField: UITextField)
}

class PasswordEditViewController: NavigationBarViewController {
    
    // MARK: - Models
    
    enum ErrorType {
        case oldPassword
        case internetConnection
        case genericError
    }
    
    enum CheckType {
        case oldPassword
        case newPassword
    }
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.register(PasswordEditCell.self, forCellWithReuseIdentifier: passwordCellIdentifier)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .flameRed
        label.font = Fonts.Main.withSize(14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Proprieties
    
    private let passwordCellIdentifier: String = "passwordEditCell"
    
    private var oldPasswordEnabled: Bool = false
    private var newPasswordEnabled: Bool = false
    
    private var oldPassword: String!
    private var newPassword: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
    }
    
    private func setupSubviews() {
        navigationBar.delegate = self
        navigationBar.setup(.settings)
        navigationBar.title = "Reset Password".uppercased()
        navigationBar.isDoneButtonEnabled = false
        
        isMotionEnabled = false
        isEdgeGesturesEnabled = false
        
        view.addSubviews(collectionView, errorLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180),
            
            errorLabel.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            errorLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
    }
    
    private func writeError(_ error: ErrorType) {
        if error == .oldPassword {
            errorLabel.text = "Old password don't match"
        } else if error == .internetConnection {
            errorLabel.text = "No internet connection"
        } else {
            errorLabel.text = "An error occured, retry"
        }
    }
}

// MARK: - BounceViewDelegate

extension PasswordEditViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        guard bounceView.tag == 0 else {
            motionDismissViewController()
            return
        }
        
//        guard ReachabilityManager.shared.isNetworkAvailable else {
//            writeError(.internetConnection)
//            return
//        }
        
        Database.User.editPassword(oldPassword: oldPassword, newPassword: newPassword) { [weak self] (successfull) in
            if successfull {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.writeError(.oldPassword)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension PasswordEditViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: passwordCellIdentifier, for: indexPath) as! PasswordEditCell
        guard indexPath.item == 0 else {
            cell.setup(titleText: "New Password", textFieldText: nil)
            cell.textField.text = nil
            cell.textField.tag = 1
            cell.passwordEditViewControllerDelegate = self
            cell.tag = 2
            return cell
        }
        cell.setup(titleText: "Old Password", textFieldText: nil)
        cell.textField.text = nil
        cell.textField.tag = 0
        cell.passwordEditViewControllerDelegate = self
        cell.tag = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
}

extension PasswordEditViewController: PasswordEditViewControllerDelegate {
    func enableCheckButton(_ checkType: CheckType, _ enabled: Bool, _ textField: UITextField) {
        navigationBar.isDoneButtonEnabled = enabled
        
        if checkType == .oldPassword {
            oldPasswordEnabled = enabled
        } else {
            newPasswordEnabled = enabled
        }
        navigationBar.isDoneButtonEnabled = oldPasswordEnabled && newPasswordEnabled
        
        if textField.tag == 0 {
            oldPassword = textField.text
        } else {
            newPassword = textField.text
        }
    }
}
