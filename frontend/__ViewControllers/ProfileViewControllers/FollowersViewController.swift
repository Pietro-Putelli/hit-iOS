//
//  FollowersViewController.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class FollowersViewController: NavigationBarViewController {
    
    // MARK: - Models
    
    lazy var segmentControl: SegmentControl = {
        let view = SegmentControl(frame: .init(origin: .zero, size: segmentControlSize))
        view.titles = ["Followers","Following"]
        view.backgroundColor = .mardiGras
        view.textColor = .white(alpha: 0.6)
        view.roundBottomCorners(cornerRadius: 16)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollView: UsersDoubleCollectionView = {
        let scrollView = UsersDoubleCollectionView()
        scrollView.contentSize.width = (view.frame.width) * 2
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.pushDelegate = self
        scrollView.addRefreshControlTarget(self, action: #selector(refreshContol(_:)), for: .valueChanged)
        return scrollView
    }()
    
    var scrollViewHeightConstraints: NSLayoutConstraint!
    
    // MARK: - Proprieties
    
    var followers = [UserDB]() {
        didSet {
            scrollView.followers = followers
        }
    }
    
    var following = [UserDB]() {
        didSet {
            scrollView.following = following
        }
    }
    
    var followersOffset: Int = 0
    var followingOffset: Int = 0
    
    var followType: FollowerType?
        
    var selectedUser: UserDB? {
        didSet {
            let username = (selectedUser == nil) ? User.shared.username : selectedUser?.username
            navigationBar.title = "@\(username ?? "")"
            navigationBar.titleLabel.setFirstCharacterColor(.irisPurple)
        }
    }
    
    private lazy var segmentControlSize: CGSize = .init(width: view.frame.width, height: 44)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        view.backgroundColor = .mardiGras
        view.addSubviews(navigationBar, segmentControl, scrollView)
        
        let xContentOffset = (followType == .follower) ? 0 : view.frame.width
        scrollView.contentOffset.x = xContentOffset
        segmentControl.updateSelectedIndex()
        
        navigationBar.setup(.navigation)
        navigationBar.delegate = self
        
        DispatchQueue.main.async {
            self.getFollowers()
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            segmentControl.heightAnchor.constraint(equalToConstant: segmentControlSize.height),
            segmentControl.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.widthAnchor.constraint(equalToConstant: view.frame.width),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
    }
    
    func setup(_ selectedUser: UserDB?, _ followType: FollowerType) {
        self.selectedUser = selectedUser
        self.followType = followType
    }
    
    @objc private func refreshContol(_ refreshControl: UIRefreshControl) {
        getFollowers()
    }
    
    private func getFollowers() {
        let userId = (selectedUser == nil) ? User.shared.id : selectedUser!.id
        
        Database.User.getFollowers(userId: userId, type: .follower, offset: followersOffset) { [weak self] (users) in
            print(users)
            self?.followers = users
        }
        Database.User.getFollowers(userId: userId, type: .following, offset: followingOffset) { [weak self] (users) in
            self?.following = users
        }
    }
}

// MARK: - Objective-C functions

extension FollowersViewController {
    @objc private func leftButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIScrollView Delegate

extension FollowersViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xContentOffSet = scrollView.contentOffset.x
        
        let translateByX = xContentOffSet / 2
        segmentControl.moveSelector(translateByX: translateByX)
        followType = (segmentControl.selectedSegmentIndex == 0) ? .follower : .following
    }
}

extension FollowersViewController: SegmentControlDelegate {
    func moveScrollView(for index: Int) {
        followType = (index == 0) ? .follower : .following

        var direction: ScrollDirection!
        if segmentControl.selectedSegmentIndex == 0 && index != 0 {
            direction = .right
        } else if segmentControl.selectedSegmentIndex == 1 && index != 1 {
            direction = .left
        }
        scrollView.setContentOffSetAnimate(for: view.frame.width, direction: direction, animationDuration: 0.3)
    }
}

extension FollowersViewController: UsersDoubleCollectionViewDelegate {
    func pushProfileViewController(_ user: UserDB) {
        guard user.id != User.shared.id else { return }
        let viewController = ProfileViewController()
        viewController.selectedUser = user
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FollowersViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        navigationController?.popViewController(animated: true)
    }
}
