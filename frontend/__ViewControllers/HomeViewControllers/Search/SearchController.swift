//
//  SearchController.swift
//  searchBar
//
//  Created by Pietro Putelli on 27/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SearchController: UIViewController {
    
    // MARK: - Models
    
    lazy var searchBar: MainSearchBar = {
        let textField = MainSearchBar()
        textField.fontSize(18)
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var exitButton: BounceView = {
        let exitButton = BounceView(image: Images.SystemIcon.Chevrons.Down, padding: 8)
        exitButton.tintColor = .white(alpha: 0.8)
        exitButton.delegate = self
        return exitButton
    }()
    
    lazy var collectionView: MainCollectionView = {
        let cv = MainCollectionView()
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset.top = 10
        cv.register(RecentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionView.SupplementaryView.HeaderSpin)
        return cv
    }()
    
    lazy var activityIndicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white(alpha: 0.6), padding: nil)
    
    lazy var edgeDismissGestures: [UIScreenEdgePanGestureRecognizer] = {
        let left = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edge(_:)))
        left.edges = .left
        let right = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edge(_:)))
        right.edges = .right
        return [left,right]
    }()
    
    // MARK: - Proprieties
    
    private let exitButtonSide: CGFloat = 45
    private let recentSearchManager = RecentSearchManager()
    
    var users = [UserDB]() {
        didSet {
            collectionView.reloadSection(index: 0)
            activityIndicator.stopAnimating()
        }
    }
    
    var recentSearches = [UserDB]() {
        didSet {
            collectionView.reloadSection(index: 1)
        }
    }
    
    var usersOffset: Int = 0
    var allUsersLoaded: Bool = false
    
    private var animationAlreadyDisplayed: Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getRecentUsers(_:)), name: .refreshRecentSearch, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getRecentUsers()
        if !searchBar.isFirstResponder {
            searchBar.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.addBottomBorder(color: .white(alpha: 0.1), width: 0.5)
    }
    
    // MARK: - Functions
    
    private func setupSubviews() {
        view.addSubviews(exitButton, searchBar, activityIndicator, collectionView)
        view.addGestureRecognizers(edgeDismissGestures)
        
        view.backgroundColor = .maire
    }
    
    private func addConstraints() {
        exitButton.anchorWidthHeight(size: .init(width: exitButtonSide, height: exitButtonSide))
        activityIndicator.anchorWidthHeight(size: .init(width: 20, height: 20))
        
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            searchBar.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            searchBar.heightAnchor.constraint(equalToConstant: exitButtonSide),
            
            activityIndicator.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        collectionView.contentInset.bottom = keyboardFrame.height + 8
    }
    
    // MARK: - Data
    
    @objc private func getRecentUsers(_ notification: Notification? = nil) {
        recentSearchManager.retriveUsers { (users) in
            self.recentSearches = users
        }
    }
    
    // MARK: - Objective functions
    
    @objc private func textDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            users = []
            return
        }
        allUsersLoaded = false
        searchUsers(input: text)
    }
    
    private func searchUsers(input: String?) {
        activityIndicator.startAnimating()
        Database.User.searchUsers(input: input ?? "", offset: usersOffset) { [weak self] (users) in
            self?.users = users
        }
    }
    
    @objc private func edge(_ gesture: UIScreenEdgePanGestureRecognizer) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - CollectionView delegate

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == 0 else {
            return recentSearches.count
        }
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section == 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.SearchUser, for: indexPath) as! SearchUserCell
            cell.setup(user: recentSearches[indexPath.item])
            cell.deleteButtonHidden = false
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.SearchUser, for: indexPath) as! SearchUserCell
        cell.setup(user: users[indexPath.item])
        cell.deleteButtonHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if !allUsersLoaded && indexPath.item == users.count - 1 {
//            usersOffset += Database.Limit
//            searchUsers(input: searchBar.text)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section == 0 else {
            return .init(width: view.frame.width - 20, height: 60)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionView.SupplementaryView.HeaderSpin, for: indexPath) as! RecentHeaderView
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = (indexPath.section == 0) ? users[indexPath.item] : recentSearches[indexPath.item]
        recentSearchManager.add(user.id)
        let viewController = ProfileViewController()
        viewController.selectedUser = user
        navigationController?.pushViewController(viewController, animated: true)
    }
    
// MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width - 20, height: 60)
    }
}

// MARK: - BounceView delegate

extension SearchController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}
