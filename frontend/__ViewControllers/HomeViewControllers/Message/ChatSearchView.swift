//
//  ChatSearchViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 04/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol ChatSearchViewDelegate: class {
    func dismiss()
}

class ChatSearchView: UIView {
    
    // MARK: - Models
    
    lazy var dismissButton: BounceView = {
        let button = BounceView(image: Images.SystemIcon.Chevrons.Down, padding: 8)
        button.delegate = self
        return button
    }()
    
    lazy var searchBar: MainSearchBar = {
        let textField = MainSearchBar()
        textField.fontSize(18)
        textField.addTarget(self, action: #selector(textFiedDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var edgeDismissGestures: [UIScreenEdgePanGestureRecognizer] = {
        let left = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edge(_:)))
        left.edges = .left
        let right = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edge(_:)))
        right.edges = .right
        return [left,right]
    }()
    
    lazy var activityIndicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white(alpha: 0.6), padding: nil)
    
    lazy var collectionView: MainCollectionView = {
       let collectionView = MainCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.top = 8
        return collectionView
    }()
    
    // MARK: - Proprieties
    
    weak var delegate: ChatSearchViewDelegate?

    override var frame: CGRect {
        didSet {
            searchBar.hideKeyboard(frame.origin.y != 0)
            if frame.origin.y  == 0 {
            }
        }
    }
    
    var allChats: [Chat]? {
        didSet {
            if allChats != nil {
                chats = allChats!.sorted(by: {$0.username < $1.username})
            }
            collectionView.reloadFirstSection()
        }
    }
    
    var chats = [Chat]() {
        didSet {
            collectionView.reloadFirstSection()
        }
    }
    
    var allUsers: [UserDB]? {
        didSet {
            if allUsers != nil {
                users = allUsers!.sorted(by: {$0.username < $1.username})
            }
            collectionView.reloadFirstSection()
        }
    }
    
    var users: [UserDB]? {
        didSet {
            collectionView.reloadFirstSection()
        }
    }
    
    var usersOffset: Int = 0
    var followersOffset: Int = 0
    var chatsOffset: Int = 0
    
    private let buttonSize: CGSize = .init(side: 40)
    private let activityIndicatorSize: CGSize = .init(side: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.addBottomBorder()
    }
    
    private func setupSubviews() {
        addSubviews(dismissButton,searchBar,activityIndicator,collectionView)
        addGestureRecognizers(edgeDismissGestures)
        
        backgroundColor = .maire
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setup(chats: [Chat]?) {
        guard let chats = chats else {
            Database.User.getFollowers(userId: User.shared.id, type: .follower, offset: followersOffset) { [weak self] (users) in
                self?.allUsers = (users.isEmpty) ? nil : users
            }
            return
        }
        self.allChats = chats
    }
    
    private func addConstraints() {
        dismissButton.anchorWidthHeight(size: buttonSize)
        activityIndicator.anchorWidthHeight(size: activityIndicatorSize)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: UIViewController.windowSafeAreaInsets.top + 12),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            searchBar.heightAnchor.constraint(equalToConstant: buttonSize.height),
            searchBar.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -8),
            
            activityIndicator.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func dismiss() {
        chats = []
        users = nil
        allChats = nil
        searchBar.text = nil
        
        delegate?.dismiss()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Objective C functions

extension ChatSearchView {
    @objc private func textFiedDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            if let allChats = allChats {
                chats = allChats
            } else {
                users = allUsers
            }
            return
        }
        
        if allChats != nil {
            Database.Chat.searchMyChat(input: text) { [weak self] (chats) in
                self?.chats = chats
            }
        } else {
            Database.User.searchUsers(input: text, offset: usersOffset) { [weak self] (users) in
                self?.users = users
            }
        }
    }
    
    @objc private func edge(_ gesture: UIScreenEdgePanGestureRecognizer) {
        dismiss()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        collectionView.contentInset.bottom = keyboardFrame.height
    }
}

// MARK: - UICollectionView Delegate - DataSource

extension ChatSearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let users = users else {
            return chats.count
        }
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let users = users else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.Chat, for: indexPath) as! ChatCell
            cell.setup(chat: chats[indexPath.item])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.SearchUser, for: indexPath) as! SearchUserCell
        cell.setup(user: users[indexPath.item], fontSize: 20)
        return cell
    }
    
    // MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = frame.width - 20
        return .init(width: cellWidth, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension ChatSearchView: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        dismiss()
    }
}
