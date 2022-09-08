//
//  ProfileViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ProfileViewController: NavigationBarViewController {

    // MARK: - Models
    
    lazy var rootScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.screenBounds)
        scrollView.delegate = self
        scrollView.backgroundColor = .maire
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView(selectedUser: self.selectedUser)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var segmentControl: SegmentControl = {
        let view = SegmentControl(frame: .init(origin: .zero, size: .init(width: self.view.frame.width, height: 44)))
        view.images = [UIImage(systemName: "tray.full.fill")!.withRenderingMode(.alwaysTemplate), UIImage(systemName: "tray.fill")!.withRenderingMode(.alwaysTemplate)]
        view.cornerRadius = 16
        view.backgroundColor = .mardiGras
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var refreshControl: UIRefreshControl = {
       let rc = UIRefreshControl()
        rc.tintColor = .purple
        rc.layer.zPosition = self.profileHeaderView.layer.zPosition + 1
        rc.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return rc
    }()
    
    lazy var commentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentOffset.x = 0
        scrollView.contentSize = .init(width: self.screenBounds.width * 2, height: 300)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.bounces = false
        scrollView.tag = self.commentScrollViewTag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var firstCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.tag = firstCollectionViewTag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var secondCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var moreView: RubberView = {
        let moreView = RubberView(frame: .init(origin: .init(x: 0, y: view.frame.height - 200), size: .init(width: view.frame.width, height: view.frame.height / 4)), yLimit: 0.2)
        moreView.backgroundColor = .red
        return moreView
    }()
        
    private var commentScrollViewHeightConstraint: NSLayoutConstraint!
    private var firstCollectionViewHeightConstraint: NSLayoutConstraint!
    private var secondCollectionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Proprieties
    
    static var shared = ProfileViewController()
    
    var selectedUser: UserDB?
    
    var myComments = [Comment]() {
        didSet {
            firstCollectionView.reloadData()
            setupScrollViewHeight()
        }
    }
    var commentsWhereTagged = [Comment]() {
        didSet {
            secondCollectionView.reloadData()
            setupScrollViewHeight()
        }
    }
    
    private var finalMoreViewOrigin: CGPoint {
        return .init(x: 0, y: 0.8 * view.frame.height)
    }
    
    var commentsOffset: Int = 0
    var usersOffset: Int = 0
    
    var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    private var imageViewHeight: CGFloat {
        return (1 / 4) * view.frame.height
    }
    
    var profileHeaderViewHeight: CGFloat {
        let height = (selectedUser == nil) ? profileHeaderView.myProfileHeight : profileHeaderView.height
        return height + imageViewHeight + 4
    }
    
    private var selectedIndex: Int = 0
    
    private var imageViewTopAnchor: NSLayoutConstraint!
    
    private let firstCollectionViewTag: Int = 1
    private let commentScrollViewTag: Int = 1

    private let segmentControlHeight: CGFloat = 44
    private let topButtonSize: CGSize = .init(width: 40, height: 40)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
        
        getComments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TemporaryUserSettings.clear()
    }
    
    // MARK: - Setup layout functions
    
    private func setupSubviews() {
        view.addSubviews(rootScrollView, navigationBar)
        
        rootScrollView.addSubviews(profileHeaderView, segmentControl, commentScrollView)
        commentScrollView.addSubviews(firstCollectionView, secondCollectionView)
        
        rootScrollView.contentSize.height = profileHeaderViewHeight + segmentControlHeight
        rootScrollView.refreshControl = refreshControl
        
        navigationBar.setup(.profile, user: selectedUser)
        navigationBar.delegate = self
        
        view.backgroundColor = .maire
    }
    
    private func addConstraints() {
        
        imageViewTopAnchor = NSLayoutConstraint(item: profileHeaderView.imageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        imageViewTopAnchor.priority = UILayoutPriority(rawValue: 900)
        view.addConstraint(imageViewTopAnchor)
        
        commentScrollViewHeightConstraint = NSLayoutConstraint(item: commentScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 300)
        view.addConstraint(commentScrollViewHeightConstraint)
        
        firstCollectionViewHeightConstraint = firstCollectionView.heightAnchor.constraint(equalToConstant: commentScrollViewHeightConstraint.constant)
        secondCollectionViewHeightConstraint = secondCollectionView.heightAnchor.constraint(equalToConstant: commentScrollViewHeightConstraint.constant)
        
        NSLayoutConstraint.activate([

            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            segmentControl.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 8),
            segmentControl.topAnchor.constraint(equalTo: rootScrollView.topAnchor, constant: profileHeaderViewHeight),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            segmentControl.heightAnchor.constraint(equalToConstant: segmentControlHeight),
            
            commentScrollView.widthAnchor.constraint(equalToConstant: view.frame.width),
            commentScrollView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),

            firstCollectionViewHeightConstraint,
            firstCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            firstCollectionView.leadingAnchor.constraint(equalTo: commentScrollView.leadingAnchor),
            
            secondCollectionViewHeightConstraint,
            secondCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            secondCollectionView.leadingAnchor.constraint(equalTo: firstCollectionView.trailingAnchor)
        ])
    }
    
    // MARK: - Setup
    
    private func setupScrollViewHeight() {
        
        var firstHeight: CGFloat = 0
        var secondHeight: CGFloat = 0
        
        let textView = CommentCell.shared.textView
        let textViewWidth = view.frame.width - 32
        
        myComments.forEach { (comment) in
            textView.text = comment.content
            firstHeight += textView.getTextViewHeight(width: textViewWidth) + CommentCell.Height
        }
        
        commentsWhereTagged.forEach { (comment) in
            textView.text = comment.content
            secondHeight += textView.getTextViewHeight(width: textViewWidth) + CommentCell.Height
        }
        
        var contentHeight = firstHeight > secondHeight ? ceil(firstHeight) : ceil(secondHeight)
        contentHeight += 60
                
        commentScrollViewHeightConstraint.constant = contentHeight
        firstCollectionViewHeightConstraint.constant = contentHeight
        secondCollectionViewHeightConstraint.constant = contentHeight
        
        rootScrollView.contentSize.height += contentHeight
    }
    
    private func setupNavigationBarAlpha(for scrollView: UIScrollView) {
        let offSet = (scrollView.contentOffset.y + scrollView.contentInset.top) / (profileHeaderView.imageView.frame.height + navigationBar.frame.height)
        navigationBar.visualEffectView.alpha = offSet
        navigationBar.titleLabelAlpha = offSet
    }
    
    private func presentMoreMenu() {
        
    }
    
    // MARK: - Data
    
    private func getComments() {
        let userId = (selectedUser != nil) ? selectedUser!.id : User.shared.id
        Database.CommentDb.getCommentWhereTagged(userId: userId, offset: commentsOffset) { [weak self] (comments) in
            self?.commentsWhereTagged = comments
        }
        
        Database.CommentDb.getUserComments(userId: userId, offset: usersOffset) { [weak self] (comments) in
            self?.myComments = comments
        }
    }
}

// MARK: - Objective-C functions

extension ProfileViewController {
    @objc private func refresh(_ sender: UIRefreshControl) {
    }
}

// MARK: - ScrollView Delegate

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xContentOffSet = scrollView.contentOffset.x
        
        guard scrollView.tag != commentScrollViewTag else {
            let translateByX = xContentOffSet / 2
            segmentControl.moveSelector(translateByX: translateByX)
            
            if xContentOffSet < view.frame.width / 2 {
                selectedIndex = 0
            } else {
                selectedIndex = 1
            }
            return
        }
        setupNavigationBarAlpha(for: scrollView)
    }
}

// MARK: - UICollectionView

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView.tag == firstCollectionViewTag else {
            return commentsWhereTagged.count
        }
        return myComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentCell
        guard collectionView.tag == firstCollectionViewTag else {
            cell.setupCell(for: commentsWhereTagged[indexPath.item])
            return cell
        }
        cell.setupCell(for: myComments[indexPath.item])
        return cell
    }
    
    // MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = view.frame.width - 8
        guard collectionView.tag == firstCollectionViewTag else {
            return .init(width: cellWidth, height: CommentCell.getCellHeight(comment: commentsWhereTagged[indexPath.item]))
        }
        return .init(width: cellWidth, height: CommentCell.getCellHeight(comment: myComments[indexPath.item]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: windowSafeAreaInsets.bottom, right: 0)
    }
}

// MARK: - ProfileViewController Delegate - For segment control scrolling

extension ProfileViewController: SegmentControlDelegate {
    func moveScrollView(for index: Int) {
        var direction: ScrollDirection!
        
        if segmentControl.selectedSegmentIndex == 0 && index != 0 {
            direction = .right
        } else if segmentControl.selectedSegmentIndex == 1 && index != 1 {
            direction = .left
        }
        commentScrollView.setContentOffSetAnimate(for: screenBounds.width, direction: direction)
    }
}

// MARK: - ProfileHeaderView Delegate

extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func editProfile() {
        let viewController = MainNavigationController(rootViewController: EditProfileViewController())
        viewController.motion()
        present(viewController, animated: true, completion: nil)
    }
    
    func pushFollowerView(_ followType: FollowerType) {
        let rootViewController = FollowersViewController()
        rootViewController.setup(selectedUser, followType)
        navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    func pushFolloweBy() {
        guard let selectedUser = selectedUser else { return }
        let viewController = UsersListViewController()
        viewController.userId = selectedUser.id
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

extension ProfileViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        if selectedUser != nil {
            if bounceView.tag == 1 {
                navigationController?.popViewController(animated: true)
            } else {
                
            }
        } else {
            let viewController = MainNavigationController(rootViewController: SettingsViewController())
            viewController.motion()
            present(viewController, animated: true, completion: nil)
        }
    }
}
