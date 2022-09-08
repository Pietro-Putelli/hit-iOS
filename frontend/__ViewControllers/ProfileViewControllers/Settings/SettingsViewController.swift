//
//  SettingsViewController.swift
//  searchBar
//
//  Created by Pietro Putelli on 13/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func logOut()
}

class SettingsViewController: NavigationBarViewController {
    
    // MARK: - Models
    
    lazy var collectionView: SettingsCollectionView = {
        let cv = SettingsCollectionView()
        cv.register(MainSettingCell.self, forCellWithReuseIdentifier: cellIdentifier)
        cv.register(LogOutCell.self, forCellWithReuseIdentifier: logOutCellIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var logoutAlertController: UIAlertController = {
        let ac = UIAlertController(title: "Log out ?".uppercased(), message: nil, preferredStyle: .alert)
        ac.addActions(okAction,cancelAction)
        ac.view.backgroundColor = .maire
        return ac
    }()
    
    lazy var okAction = UIAlertAction(title: "OK", style: .default) { (_) in
        // logout
    }
    
    lazy var cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
    
    // MARK: - Proprieties
    
    private let cellIdentifier = "cell"
    private let logOutCellIdentifier = "logOut"
    
    private let titles = ["Appearance","Notification","Chat","About"]
    private let images = [Images.Edit,Images.Notification,Images.Paperplane1,Images.Info]
    private let viewControllers = [AppearanceSettingsViewController(),NotificationSettingsViewController(),ChatSettingsViewController(),AboutViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
    }
    
    private func setupSubviews() {
        navigationBar.setup(.settings, chevron: .down)
        navigationBar.title = "Settings".uppercased()
        navigationBar.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item == titles.count else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MainSettingCell
            cell.title = titles[indexPath.item].uppercased()
            cell.image = images[indexPath.item]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: logOutCellIdentifier, for: indexPath) as! LogOutCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(viewControllers[indexPath.item], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 60)
    }
}

extension SettingsViewController: SettingsViewControllerDelegate {
    func logOut() {
        present(logoutAlertController, animated: true, completion: nil)
    }
}

extension SettingsViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        dismiss(animated: true, completion: nil)
    }
}
