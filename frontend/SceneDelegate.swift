//
//  SceneDelegate.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let mainTabBarController = MainTabBarController()
    
    static var shared: SceneDelegate? {
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return nil
        }
        return delegate
    }
    
    var tabBar: UITabBar {
        return mainTabBarController.tabBar
    }
    
    var tabBarHeight: CGFloat {
        return tabBar.frame.height
    }
    
    lazy var taBarInitialYOrigin = tabBar.frame.origin.y
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setup(windowScene: windowScene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

// MARK: - Setup

extension SceneDelegate {
    
    private func setup(windowScene scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()
    }
    
    private func globalSettings() {
        UIWindow.appearance().tintColor = .perla
        UINavigationBar.appearance().backgroundColor = .maire
        UIBarButtonItem.appearance().tintColor = .perla
            UIRefreshControl.appearance().tintColor = .perla
        UICollectionViewCell.appearance().backgroundColor = .mardiGras
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var complementary = tabBarHeight - scrollView.contentOffset.x / 5
        complementary *= (complementary < 0) ? -1.1 : 1.1
        tabBar.frame.origin.y = taBarInitialYOrigin + complementary
    }
    
    func hideTabBar(_ hidden: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.tabBar.frame.origin.y = hidden ? self.taBarInitialYOrigin + self.tabBarHeight : self.taBarInitialYOrigin
        }
    }
    
    func addSubview(_ subview: UIView) {
        if !subview.isDescendant(of: window!) {
            window?.addSubview(subview)
        }
    }
}
