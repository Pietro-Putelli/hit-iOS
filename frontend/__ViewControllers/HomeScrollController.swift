//
//  HomeScrollController.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

protocol HomeScrollControllerDelegate: class {
    func scroll(to: HomeScrollController.Page, direction: ScrollDirection)
    func enableScrolling(_ enabled: Bool)
}

class HomeScrollController: UIViewController {
    
    // MARK: - Models
    
    enum Page: Int {
        case search = -1
        case home = 0
        case message = 1
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: view.bounds)
        sv.contentSize.width = (UIScreen.main.bounds.width) * 3
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.isPagingEnabled = true
        sv.delegate = self
        return sv
    }()
    
    lazy var homeViewController: HomeViewController = {
        let viewController = HomeViewController()
        viewController.delegate = self
        return viewController
    }()
    
    lazy var messageViewController: ChatsViewController = {
       let viewController = ChatsViewController()
        viewController.delegate = self
        return viewController
    }()
    
    lazy var searchViewController: SearchViewController = {
       let viewController = SearchViewController()
        viewController.delegate = self
        return viewController
    }()
    
    lazy var homeNavigationController = HomeNavigationController(rootViewController: homeViewController)
    lazy var messageNavigationController = ChatsNavigationController(rootViewController: messageViewController)
    lazy var profileNavigationController = SearchNavigationController(rootViewController: searchViewController)
    
    // MARK: - Proprieties
    
    private var homeView: UIView {
        return homeNavigationController.view
    }
    
    private var messageView: UIView {
        return messageNavigationController.view
    }
    
    private var profileView: UIView {
        return profileNavigationController.view
    }
    
    private var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    private var lastContentOffset: CGFloat = 0
    private let delta: CGFloat = 10
    
    private var selectedIndex: Page = .home
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(scrollView)
        
        add(profileNavigationController, homeNavigationController, messageNavigationController)
        setupFrames()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentOffset.x = view.frame.width
    }
    
    private func setupFrames() {
        profileView.frame = screenBounds

        homeView.frame = screenBounds
        homeView.frame.origin.x = screenBounds.width

        messageView.frame = screenBounds
        messageView.frame.origin.x = 2 * screenBounds.width
    }
    
    private func add(_ childs: UIViewController...) {
        for child in childs {
            scrollView.addSubview(child.view)
            addChild(child)
            child.didMove(toParent: self)
        }
    }
}

// MARK: - UIScrollView Delegate

extension HomeScrollController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset > scrollView.contentOffset.x {
            if lastContentOffset < screenBounds.width && selectedIndex == .home {
                selectedIndex = .search
            } else if lastContentOffset < screenBounds.width + delta && selectedIndex == .message {
                selectedIndex = .home
            }
        } else if lastContentOffset < scrollView.contentOffset.x {
            if lastContentOffset > screenBounds.width - delta && selectedIndex == .search {
                selectedIndex = .home
            } else if lastContentOffset > 2 * screenBounds.width - delta && selectedIndex == .home {
                selectedIndex = .message
            }
        }
        lastContentOffset = scrollView.contentOffset.x
        SceneDelegate.shared?.scrollViewDidScroll(scrollView)
    }
}

// MARK: - HomeScrollController Delegate

extension HomeScrollController: HomeScrollControllerDelegate {
    func scroll(to: Page, direction: ScrollDirection) {
        scrollView.setContentOffSetAnimate(for: screenBounds.width, direction: direction, animationDuration: 0.3)
        selectedIndex = to
    }
    
    func enableScrolling(_ enabled: Bool) {
        scrollView.isScrollEnabled = enabled
    }
}
