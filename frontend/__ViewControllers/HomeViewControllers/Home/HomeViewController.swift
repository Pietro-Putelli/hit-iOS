//
//  HomeViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Models
    
    lazy var searchView: BounceView = {
        let view = BounceView(image: Images.Network, padding: 7)
        view.tintColor = .perla
        view.delegate = self
        return view
    }()
    
    lazy var chatView: BounceView = {
        let view = BounceView(image: Images.Paperplane, padding: 9)
        view.tintColor = .perla
        view.tag = 1
        view.delegate = self
        return view
    }()
    
    lazy var navigationBackground = MaireGradientView()
    
    lazy var collectionView: MainCollectionView = {
        let collectionView = MainCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .irisPurple
        rc.addTarget(self, action: #selector(refreshControl(_:)), for: .valueChanged)
        return rc
    }()
    
    lazy var shareView: ShareView = {
        let shareView = ShareView(frame: .init(origin: initialShareViewOrigin, size: view.frame.size), yLimit: 0.9)
        shareView.backgroundColor = .mardiGras
        shareView.delegate = self
        return shareView
    }()
    
    // MARK: - Proprieties
    
    weak var delegate: HomeScrollControllerDelegate?
    
    private let suggestedUsersLimit: Int = 10
    private let sideItemWidth: CGFloat = 40
    
    private var finalShareViewOrigin: CGPoint {
        return .init(x: 0, y: 0.1 * view.frame.height)
    }
    
    private var initialShareViewOrigin: CGPoint {
        return .init(x: 0, y: view.frame.height)
    }
    
    var navigationBackgroundHeight: CGFloat {
        return windowSafeAreaInsets.top + 70
    }
    
    var suggestedUsers = [UserDB]()
    
    var comments = [Comment]() {
        didSet {
            collectionView.reloadFirstSection()
            refreshControl.endRefreshing()
        }
    }
    
    private var allCommentsLoaded: Bool = false
    private var offset: Int = 0
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
        
        addObserverRefresh()
        getFollowingComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.enableScrolling(true)
    }
    
    // MARK: - Data functions
    
    private func getFollowingComments(reload: Bool = false) {
        Database.CommentDb.getFollowingComments(offset: offset) { [weak self] (comments) in
            if !reload {
                self?.comments.appendIfNoContains(comments)
                self?.allCommentsLoaded = comments.count < Database.Limit
            } else {
                self?.comments = comments
            }
        }
    }
    
    // MARK: - Setup functions
    
    private func setupSubviews() {
        view.addSubviews(collectionView, navigationBackground, searchView, chatView)
        view.backgroundColor = .maire
        
        collectionView.addSubview(refreshControl)
    }
    
    private func addConstraints() {
        let horizontalInset: CGFloat = 16
        
        searchView.anchorWidthHeight(size: .init(width: sideItemWidth, height: sideItemWidth))
        chatView.anchorWidthHeight(size: .init(width: sideItemWidth, height: sideItemWidth))
        
        collectionView.fillSuperview()
        
        NSLayoutConstraint.activate([
            
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalInset),
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            
            chatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalInset),
            chatView.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: -4),
            
            navigationBackground.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackground.heightAnchor.constraint(equalToConstant: navigationBackgroundHeight)
        ])
    }
    
    private func addObserverRefresh() {
        NotificationCenter.default.addObserver(forName: .refreshHome, object: nil, queue: .main) { [weak self] (_) in
            self?.refreshControl.beginRefreshing()
            self?.getFollowingComments()
        }
    }
    
    // MARK: - Objc functions
    
    @objc private func refreshControl(_ refreshControler: UIRefreshControl) {
        if refreshControler.state == .highlighted {
            view.generateHapticFeedback(for: .soft)
        }
        offset = 0
        getFollowingComments(reload: true)
    }
}

// MARK: - CollectionView delegate, datasounce

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.Comment, for: indexPath) as! CommentCell
        cell.setupCell(for: comments[indexPath.item])
        cell.textView.commentDelegate = self
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !allCommentsLoaded && indexPath.item == comments.count - 1 {
            offset += Database.Limit
            getFollowingComments()
            print("loading more")
        }
    }
    
    // MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = view.frame.width - 20
        return .init(width: cellWidth, height: CommentCell.getCellHeight(comment: comments[indexPath.item]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}

// MARK: - BounceView delegate

extension HomeViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        guard bounceView.tag == 0 else {
            delegate?.scroll(to: .message, direction: .right)
            return
        }
        delegate?.scroll(to: .search, direction: .left)
    }
}

// MARK: - CommentTextView Delegate

extension HomeViewController: CommentTextViewDelegate {
    func pushProfileViewController(username: String) {
        Database.User.getUserBy(username: username) { [weak self] (user) in
            guard let user = user else { return }
            let viewController = ProfileViewController()
            viewController.selectedUser = user
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - CommentCellDelegate

extension HomeViewController: CommentCellDelegate {
    
    func presentShareView(commentId: Int) {
        SceneDelegate.shared?.addSubview(shareView)
        delegate?.enableScrolling(false)
        shareView.setupUsers()
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.shareView.originalFrame.origin.y = self.finalShareViewOrigin.y
        }, completion: nil)
    }
    
    func pushLikedByViewController(commentId: Int) {
        let viewController = UsersListViewController()
        viewController.commentId = commentId
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushProfileViewController(userId: Int) {
        guard userId != User.shared.id else { return }
        let viewController = ProfileViewController()
        Database.User.getUserBy(userId: userId) { (user) in
            viewController.selectedUser = user
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - RubberViewDelegate

extension HomeViewController: RubberViewDelegate {
    
    func viewDidDisappear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.shareView.remove()
        }
        delegate?.enableScrolling(true)
    }
    
    func didEndScrolling(_ panGesture: UIPanGestureRecognizer) {
        shareView.collectionView.isScrollEnabled = true
    }
    
    func didBeginScrolling(_ panGesture: UIPanGestureRecognizer) {
        SceneDelegate.shared?.window?.endEditing(true)
    }
}
