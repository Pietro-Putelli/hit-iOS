//
//  UIViewControllerExtension.swift
//  Hit
//
//  Created by Pietro Putelli on 22/04/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import Motion

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
    
    func setTitleFont(for font: UIFont) {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
    }
}

extension UIViewController {
    
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard1() {
        view.endEditing(true)
    }
    
    var safeAreaInsets: UIEdgeInsets {
        let window = UIApplication.shared.windows.first!
        return window.safeAreaInsets
    }
    
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension UIViewController {
    var windowSafeAreaInsets: UIEdgeInsets {
        guard let window = UIApplication.shared.windows.first else {
            return .zero
        }
        return window.safeAreaInsets
    }
    
    static var windowSafeAreaInsets: UIEdgeInsets {
        guard let window = UIApplication.shared.windows.first else {
            return .zero
        }
        return window.safeAreaInsets
    }
}

extension UIViewController {
    func addScreenEdgeDismissingGesture() {
        let leftPopEdgeGesture = UIScreenEdgePanGestureRecognizer()
        leftPopEdgeGesture.addTarget(self, action: #selector(popViewControllerGesture))
        leftPopEdgeGesture.edges = .left
        
        let rightPopEdgeGesture = UIScreenEdgePanGestureRecognizer()
        rightPopEdgeGesture.addTarget(self, action: #selector(popViewControllerGesture))
        rightPopEdgeGesture.edges = .right
        
        view.addGestureRecognizers(rightPopEdgeGesture,leftPopEdgeGesture)
    }
    
    @objc private func popViewControllerGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        motionDismissViewController()
    }
}

extension UIViewController {
    func motion(motionTransitionType: MotionTransitionAnimationType = .autoReverse(presenting: .zoom)) {
        isMotionEnabled = true
        self.motionTransitionType = motionTransitionType
        self.modalPresentationStyle = .fullScreen
    }
}
