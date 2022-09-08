//
//  ScrollCollectionViews.swift
//  searchBar
//
//  Created by Pietro Putelli on 05/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

protocol UsersDoubleCollectionViewDelegate: class {
    func pushProfileViewController(_ user: UserDB)
}

class UsersDoubleCollectionView: UIScrollView {
    
    // MARK: - Models
    
    lazy var firstCollectionView: UICollectionView = {
        let cv = UsersCollectionView()
        cv.delegate = self
        cv.dataSource = self
        cv.refreshControl = firstRefreshControl
        cv.tag = self.firstCollectionViewTag
        return cv
    }()
    
    lazy var secondCollectionView: UICollectionView = {
        let cv = UsersCollectionView()
        cv.delegate = self
        cv.dataSource = self
        cv.refreshControl = secondRefreshControl
        return cv
    }()
    
    lazy var firstRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .irisPurple
        refreshControl.tag = self.firstCollectionViewTag
        return refreshControl
    }()
    
    lazy var secondRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .irisPurple
        return refreshControl
    }()
    
    // MARK: - Proprieties
    
    weak var pushDelegate: UsersDoubleCollectionViewDelegate?
    
    var followers = [UserDB]() {
        didSet {
            firstCollectionView.reloadFirstSection()
            firstRefreshControl.endRefreshing()
        }
    }
    
    var following = [UserDB]() {
        didSet {
            secondCollectionView.reloadFirstSection()
            secondRefreshControl.endRefreshing()
        }
    }
    
    var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    private let firstCollectionViewTag: Int = 1
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
        addConstraints()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        isPagingEnabled = true
        bounces = true
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(firstCollectionView, secondCollectionView)
    }
    
    private func addConstraints() {
        firstCollectionView.anchorWidthHeight(size: screenBounds.size)
        secondCollectionView.anchorWidthHeight(size: screenBounds.size)
        
        NSLayoutConstraint.activate([
            firstCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondCollectionView.leadingAnchor.constraint(equalTo: firstCollectionView.trailingAnchor)
        ])
    }
    
    func addRefreshControlTarget(_ target: Any?, action: Selector, for controlState: UIControl.Event) {
        firstRefreshControl.addTarget(target, action: action, for: controlState)
        secondRefreshControl.addTarget(target, action: action, for: controlState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionView Delegate

extension UsersDoubleCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView.tag == firstCollectionViewTag else {
            return following.count
        }
        return followers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCell
        guard collectionView.tag == firstCollectionViewTag else {
            cell.setup(user: following[indexPath.item])
            return cell
        }
        cell.setup(user: followers[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = (collectionView.tag == firstCollectionViewTag) ? followers[indexPath.item] : following[indexPath.item]
        pushDelegate?.pushProfileViewController(user) 
    }
    
    // MARK: - UICollectionView FlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: screenBounds.size.width - 8, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 0, bottom: 0, right: 0)
    }
}
 
