//
//  ShareView.swift
//  Hit
//
//  Created by Pietro Putelli on 31/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ShareView: RubberView {
    
    // MARK: - Models
    
    lazy var sendButton: ShareSendButton = {
        let button = ShareSendButton(frame: .init(origin: .zero, size: .init(width: frame.width - 32, height: 44)))
        button.center = .init(x: frame.width / 2, y: sendButtonBottomInset)
        button.addTarget(self, action: #selector(sendButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset.bottom = 8
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(ShareUserCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    lazy var searchBar: MainSearchBar = {
        let textField = MainSearchBar(frame: .init(origin: .zero, size: searchBarSize), constraints: false)
        textField.center = .init(x: center.x, y: 42)
        textField.fontSize(18)
        textField.addBottomBorder()
        textField.addTarget(self, action: #selector(textFiedDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var spinner: NVActivityIndicatorView = {
       let spinner = NVActivityIndicatorView(frame: spinerFrame)
        spinner.type = .circleStrokeSpin
        spinner.color = .white(alpha: 0.6)
        return spinner
    }()
    
    // MARK: - Proprieties
    
        // MARK: - Frames
    
    var sendButtonBottomInset: CGFloat {
        return frame.height * 0.84 - UIViewController.windowSafeAreaInsets.bottom / 4
    }
    
    var collectionViewFrame: CGRect {
        return .init(origin: .init(x: 0, y: 80), size: .init(width: frame.width, height: sendButton.frame.origin.y - 88))
    }
      
    var spinerFrame: CGRect {
        return .init(center: .init(x: searchBar.frame.width, y: searchBar.center.y), size: .init(side: 20))
    }
    
    var searchBarSize: CGSize {
        return .init(width: frame.width - 32, height: 40)
    }
    
    var users = [UserDB]() {
        didSet {
            collectionView.reloadFirstSection()
            spinner.stopAnimating()
        }
    }
    
    var followingUsers = [UserDB]()
    
    var followingOffset: Int = 0
    var usersOffset: Int = 0
    
    var selectedIds = [Int]() {
        didSet {
            sendButton.isEnabled = !selectedIds.isEmpty
        }
    }
    
    var isSearching: Bool = false
    
    override init(frame: CGRect, yLimit: CGFloat) {
        super.init(frame: frame, yLimit: yLimit)
        
        addSubviews(collectionView, sendButton, searchBar, spinner)
        
        panGesture.delegate = self
    }
    
    func setupUsers() {
        Database.User.getFollowers(userId: User.shared.id, type: .following, offset: followingOffset) { [weak self] (users) in
            self?.users = users
            self?.followingUsers = users
        }
    }
    
    func remove() {
        removeFromSuperview()
        selectedIds = []
        collectionView.reloadData()
    }
    
    @objc private func textFiedDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            users = followingUsers
            return
        }
        spinner.startAnimating()
        Database.User.searchUsers(input: text, offset: usersOffset) { [weak self] (users) in
            self?.users = users
        }
    }
    
    @objc private func sendButton(_ button: UIButton) {
        button.pulse(hapticFeedback: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShareView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShareUserCell
        cell.setup(user: users[indexPath.item])
        cell.isSelect = selectedIds.contains(indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ShareUserCell else { return }
        cell.isSelect = !cell.isSelect
        
        let userId = users[indexPath.item].id
        if (cell.isSelect && !selectedIds.contains(userId)) {
            selectedIds.append(userId)
        } else if (!cell.isSelect && selectedIds.contains(userId)) {
            selectedIds = selectedIds.filter { $0 != userId }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UICollectionView FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width - 8, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension ShareView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGesture = gestureRecognizer as! UIPanGestureRecognizer
        let direction = panGesture.velocity(in: self).y
        collectionView.isScrollEnabled = !(direction > 0 && collectionView.contentOffset.y == 0)
        return false
    }
}
