//
//  TagView.swift
//  Hit
//
//  Created by Pietro Putelli on 03/09/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol TagViewDelegate: class {
    func didSelect(_ user: UserDB)
}

class TagView: UIView {

    // MARK: - Models
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(horizontal: 0, vertical: 16)
        collectionView.alwaysBounceVertical = true
        collectionView.register(SearchUserCell.self, forCellWithReuseIdentifier: CollectionView.Cells.SearchUser)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var inputLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white(alpha: 0.8)
        label.font = Fonts.Main.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var snailIcon = MainImageView(image: Images.Snail, tintColor: .electricIndigo)
    lazy var activityIndicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white(alpha: 0.6), padding: nil)
    
    // MARK: - Proprieties
    
    weak var delegate: TagViewDelegate?
    
    var inputText: String? {
        didSet {
            inputLabel.text = inputText
            searchUsers()
        }
    }
    
    var users = [UserDB]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var usersOffset: Int = 0
    
    private let textFieldHeight: CGFloat = 30
    private let activityIndicatorSize: CGSize = .init(side: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .maire
        addSubviews(collectionView, inputLabel, activityIndicator, snailIcon)
        
        addConstraints()
    }
    
    private func addConstraints() {
        activityIndicator.anchorWidthHeight(size: activityIndicatorSize)
        snailIcon.anchorWidthHeight(size: activityIndicatorSize)
        
        NSLayoutConstraint.activate([
            snailIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            snailIcon.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            
            inputLabel.heightAnchor.constraint(equalToConstant: textFieldHeight),
            inputLabel.leadingAnchor.constraint(equalTo: snailIcon.trailingAnchor, constant: 8),
            inputLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            inputLabel.centerYAnchor.constraint(equalTo: snailIcon.centerYAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: inputLabel.bottomAnchor, constant: 8),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func searchUsers() {
        activityIndicator.startAnimating()
        Database.User.searchUsers(input: inputText ?? "", offset: usersOffset) { [weak self] (users) in
            self?.users = users
            self?.activityIndicator.stopAnimating()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionView Delegate - DataSource

extension TagView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.SearchUser, for: indexPath) as! SearchUserCell
        cell.rightChevron.isHidden = true
        cell.setup(user: users[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(users[indexPath.item])
    }
    
// MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: frame.width - 20, height: 60)
    }
}
