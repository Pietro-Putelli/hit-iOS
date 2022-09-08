//
//  UsersLikedCommentViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 31/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class UsersListViewController: NavigationBarViewController {
    
    lazy var collectionView: UsersCollectionView = {
        let collectionView = UsersCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .irisPurple
        return refreshControl
    }()
    
    var commentId: Int!
    var userId: Int!
    
    var users = [UserDB]() {
        didSet {
            collectionView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    var offset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setup(.navigation)
        navigationBar.delegate = self
        navigationBar.title = (userId == nil) ? "Liked by" : "Followed by"
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        getUsers()
    }
    
    private func getUsers() {
        guard userId == nil else {
            Database.User.getFollowedByUsers(userId: userId, offset: offset) { [weak self] (users) in
                self?.users = users
            }
            return
        }
        Database.User.getUsersLikedComment(commentId: commentId, offset: offset) { [weak self] (users) in
            self?.users = users
        }
    }
    
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        getUsers()
    }
}

// MARK: - UICollectionView Delegate - DataSource

extension UsersListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCell
        cell.setup(user: users[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ProfileViewController()
        viewController.selectedUser = users[indexPath.item]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - UICollectionView FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 8, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension UsersListViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        navigationController?.popViewController(animated: true)
    }
}
