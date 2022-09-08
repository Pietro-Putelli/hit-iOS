//
//  SuggestedUsersCell.swift
//  searchBar
//
//  Created by Pietro Putelli on 27/07/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class SuggestedUsersCell: UICollectionViewCell {
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.contentInset = .init(top: 4, left: 4, bottom: 4, right: 4)
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(SuggestedUserCell.self, forCellWithReuseIdentifier: "suggestedUser")
        return cv
    }()
    
    var suggestedUsers: [UserDB] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - CollectionView delegate, datasource

extension SuggestedUsersCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestedUser", for: indexPath) as! SuggestedUserCell
        cell.setup(user: suggestedUsers[indexPath.item])
        return cell
    }
    
    // MARK: - Flow layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.height - 20, height: frame.height - 20)
    }
}
