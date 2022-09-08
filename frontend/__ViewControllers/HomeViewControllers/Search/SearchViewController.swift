//
//  SearchViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
// MARK: - Models
    
    lazy var searchBar: SearchBarView = {
        let sb = SearchBarView(image: nil)
        sb.delegate = self
        return sb
    }()
    
    lazy var searchBarBackground = MaireGradientView()
    
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
    
    // MARK: - Proprieties
    
    weak var delegate: HomeScrollControllerDelegate?
    
    var searchBarSize: CGSize {
        return .init(width: view.frame.width - 60, height: 44)
    }
    
    private let suggestedUsersLimit: Int = 10
    
    var navigationBackgroundHeight: CGFloat {
        return windowSafeAreaInsets.top + 70
    }
    
    var suggestedUsers = [UserDB]()
    var suggestedComments = [Comment]()
    
    var usersOffset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
        
        getSuggestedUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.enableScrolling(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.enableScrolling(true)
    }
    
    // MARK: - Data functions
    
    private func getSuggestedUsers() {
        Database.User.getSuggestedUsers(limit: suggestedUsersLimit, offset: usersOffset) { [weak self] (users) in
            self?.suggestedUsers = users
            self?.collectionView.reloadSections(IndexSet(arrayLiteral: 0,1))
            self?.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Setup functions
    
    private func setupSubviews() {
        view.addSubviews(collectionView, searchBarBackground, searchBar)
        view.backgroundColor = .maire
        
        collectionView.addSubview(refreshControl)
    }
    
    private func addConstraints() {
        searchBar.anchorWidthHeight(size: searchBarSize)
        collectionView.fillSuperview()
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchBarBackground.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarBackground.heightAnchor.constraint(equalToConstant: navigationBackgroundHeight)
        ])
    }
    
    // MARK: - Objc functions
    
    @objc private func refreshControl(_ refreshControler: UIRefreshControl) {
        if refreshControler.state == .highlighted {
            view.generateHapticFeedback(for: .soft)
        }
        getSuggestedUsers()
    }
}

// MARK: - CollectionView delegate, datasounce

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == 0 else {
            return suggestedComments.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section == 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.Comment, for: indexPath) as! CommentCell
            cell.setupCell(for: suggestedComments[indexPath.item])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.SuggestedUser, for: indexPath) as! SuggestedUsersCell
        cell.suggestedUsers = suggestedUsers
        return cell
    }
    
    // MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = view.frame.width - 20
        guard indexPath.section == 1 else {
            return .init(width: cellWidth, height: view.frame.width * (1 / 2.5))
        }
        return .init(width: cellWidth, height: CommentCell.getCellHeight(comment: suggestedComments[indexPath.item]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}

// MARK: - BounceView delegate

extension SearchViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        let searchNavigationController = InteractivePopDismissNavigationController(rootViewController: SearchController())
        searchNavigationController.isMotionEnabled = true
        searchNavigationController.modalPresentationStyle = .fullScreen
        searchNavigationController.motionTransitionType = .autoReverse(presenting: .zoom)
        
        present(searchNavigationController, animated: true, completion: nil)
    }
}
