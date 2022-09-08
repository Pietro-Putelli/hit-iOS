//
//  MessageViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
    // MARK: - Models
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.contentInset.top = searchBarHeight
        cv.delegate = self
        cv.dataSource = self
        cv.alwaysBounceVertical = true
        cv.register(MessageCell.self, forCellWithReuseIdentifier: CollectionView.Cells.Message)
        return cv
    }()
    
    lazy var backButton: BounceView = {
        let view = BounceView(image: Images.SystemIcon.Chevrons.Left, padding: 7)
        view.tintColor = .perla
        view.delegate = self
        return view
    }()
    
    lazy var newChatButton: BounceView = {
        let view = BounceView(image: Images.Plus, padding: 9)
        view.tintColor = .perla
        view.delegate = self
        view.tag = 1
        return view
    }()
    
    let titleLabel = MainLabel(text: "Messages", textColor: .white(alpha: 0.8), fontSize: 20)
    let searchBarBackground = MaireGradientView()
    
    // MARK: - Proprieties
    
    weak var delegate: HomeScrollControllerDelegate?
    
    private let topButtonSize: CGSize = .init(side: 40)
    private let searchBarHeight: CGFloat = 70
    
    var messages = [
        Message(id: 1, name: "Elon Musk", lastMessage: "Hey coglione"),
        Message(id: 2, name: "Steve Jobs", lastMessage: "Hungry?")
    ]
    
    let images = [Images.Elon, Images.Steve]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
    }
    
    private func setupSubviews() {
        view.addSubviews(collectionView,searchBarBackground,newChatButton,backButton,titleLabel)
        
        view.backgroundColor = .maire
    }
    
    private func addConstraints() {
        newChatButton.anchorWidthHeight(size: topButtonSize)
        backButton.anchorWidthHeight(size: topButtonSize)
        
        collectionView.fillSuperview()
        
        NSLayoutConstraint.activate([
            searchBarBackground.heightAnchor.constraint(equalToConstant: windowSafeAreaInsets.top + searchBarHeight),
            searchBarBackground.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.centerYAnchor.constraint(equalTo: newChatButton.centerYAnchor),
            
            newChatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            newChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: newChatButton.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.enableScrolling(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.enableScrolling(true)
    }
}

// MARK: - UICollectionView Delegate - DataSource

extension ChatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.Message, for: indexPath) as! MessageCell
        cell.setup(message: messages[indexPath.item])
        cell.profileImageView.imageView.image = images[indexPath.item]
        return cell
    }
    
    // MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = view.frame.width - 20
        return .init(width: cellWidth, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension ChatsViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        guard bounceView.tag == 1 else {
            delegate?.scroll(to: .home, direction: .left)
            return
        }
    }
}
