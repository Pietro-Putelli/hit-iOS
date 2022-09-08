//
//  ViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var lastItemSelected: Int = 0
    
    private let emptyImages = Images.TabBar.Empty
    private let fillImages = Images.TabBar.Fill
    
    lazy var profileNavigationController = ProfileNavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User(id: 1, username: "PietroPutelli", name: "Pietro Putelli", bio: "Una cosa nella vita conta, la furbizia il resto è secondario", instagram: "pietro_putelli", link: "www.finixinc.com")
        UserDefaults.setUser(user)
        
        viewControllers = [HomeScrollController(),CreateCommentNavigationController(),profileNavigationController]
        tabBar.barTintColor = .maire
        tabBar.tintColor = .perla
        
        guard let items = tabBar.items else { return }
        for index in 0..<items.count {
            items[index].tag = index
            items[index].image = emptyImages[index]
            items[index].selectedImage = fillImages[index]
            items[index].imageInsets = .init(top: 10, left: 0, bottom: -10, right: 0)
        }
    }
    
    private func presentCreateCommentViewController() {
        let viewController = CreateCommentNavigationController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.motion(motionTransitionType: .autoReverse(presenting: .slide(direction: .up)))
        SceneDelegate.shared?.mainTabBarController.present(viewController, animated: true, completion: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        
        switch item {
        case items.first:
            lastItemSelected = 0
            navigationController?.popToRootViewController(animated: true)
        case items[1]:
            presentCreateCommentViewController()
            DispatchQueue.main.async {
                self.selectedIndex = self.lastItemSelected
            }
        case items.last:
            lastItemSelected = 2
        default: break
        }
    }
}
