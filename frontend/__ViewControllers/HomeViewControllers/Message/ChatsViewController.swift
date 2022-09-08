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
    
    lazy var collectionView: MainCollectionView = {
        let collectionView = MainCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var backButton: BounceView = {
        let view = BounceView(image: Images.SystemIcon.Chevrons.Left, padding: 6)
        view.delegate = self
        return view
    }()
    
    lazy var searchButton: BounceView = {
        let view = BounceView(image: Images.SearchGlass, padding: 6, tag: 1)
        view.delegate = self
        return view
    }()
    
    lazy var newChatButton: BounceView = {
        let view = BounceView(image: Images.Plus, padding: 9, tag: 2)
        view.delegate = self
        return view
    }()
    
    lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .purple
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var searchView: ChatSearchView = {
        let sv = ChatSearchView(frame: searchViewFrame)
        sv.delegate = self
        return sv
    }()
    
    let titleLabel = MainLabel(text: "Messages", textColor: .white(alpha: 0.8), fontSize: 20)
    let navigationBackground = MaireGradientView()
    
    // MARK: - Proprieties
    
    weak var delegate: HomeScrollControllerDelegate?
    
    private let topButtonSize: CGSize = .init(side: 40)
    
    var searchViewFrame: CGRect {
        return .init(origin: .init(x: 0, y: view.frame.height), size: view.bounds.size)
    }
    
    var navigationBackgroundHeight: CGFloat {
        return windowSafeAreaInsets.top + 70
    }
    
    var chats = [Chat]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let images = [Images.Elon, Images.Steve]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addConstraints()
    }
    
    private func setupSubviews() {
        view.addSubviews(collectionView,navigationBackground,newChatButton,backButton,titleLabel,searchButton,searchView)
        
        view.backgroundColor = .maire
        hidesBottomBarWhenPushed = true
        collectionView.refreshControl = refreshControl
        
        getChats()
    }
    
    func getChats() {
        Database.Chat.get { [weak self] (chats) in
            self?.chats = chats
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.anchorWidthHeight(size: topButtonSize, [
            newChatButton,backButton,searchButton
        ])
        
        collectionView.fillSuperview()
        NSLayoutConstraint.activate([
            navigationBackground.heightAnchor.constraint(equalToConstant: navigationBackgroundHeight),
            navigationBackground.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.centerYAnchor.constraint(equalTo: newChatButton.centerYAnchor),
            
            newChatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            newChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            searchButton.centerYAnchor.constraint(equalTo: newChatButton.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: newChatButton.leadingAnchor, constant: -8),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: newChatButton.centerYAnchor)
        ])
    }
    
    private func showSearchView(_ isShown: Bool) {
        delegate?.enableScrolling(!isShown)
        let yOrigin = isShown ? 0 : view.frame.height
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.searchView.frame.origin.y = yOrigin
        }, completion: nil)
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

// MARK: - Objective C functions
extension ChatsViewController {
    @objc private func textDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
    }
    
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        getChats()
    }
}

// MARK: - UICollectionView Delegate - DataSource

extension ChatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionView.Cells.Chat, for: indexPath) as! ChatCell
        cell.setup(chat: chats[indexPath.item])
        cell.profileImageView.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(ChatViewController(), animated: true)
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
        switch bounceView.tag {
        case 0:
            delegate?.scroll(to: .home, direction: .left)
        case 1,2:
            showSearchView(true)
            let array = (bounceView.tag == 1) ? chats : nil
            searchView.setup(chats: array)
        default: break
        }
    }
}

// MARK: -  ChatSearchView Delegate

extension ChatsViewController: ChatSearchViewDelegate {
    func dismiss() {
        showSearchView(false)
    }
}
