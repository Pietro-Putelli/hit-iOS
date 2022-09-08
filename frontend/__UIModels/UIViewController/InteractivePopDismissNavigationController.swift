//
//  InteractivePopDismissNavigationController.swift
//  chat
//
//  Created by Pietro Putelli on 22/06/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class InteractivePopDismissNavigationController: UINavigationController {
    
    private lazy var fullWidthBackGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarHidden(true, animated: false)
        setupFullWidthBackGesture()
    }
    
    private func setupFullWidthBackGesture() {
        guard let interactivePopGestureRecognizer = interactivePopGestureRecognizer,
            let targets = interactivePopGestureRecognizer.value(forKey: "targets") else {
                return
        }
        
        fullWidthBackGestureRecognizer.setValue(targets, forKey: "targets")
        fullWidthBackGestureRecognizer.delegate = self
        view.addGestureRecognizer(fullWidthBackGestureRecognizer)
    }
}

extension InteractivePopDismissNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isSystemSwipeToBackEnabled = interactivePopGestureRecognizer?.isEnabled == true
        let isThereStackedViewControllers = viewControllers.count > 1
        return isSystemSwipeToBackEnabled && isThereStackedViewControllers
    }
}

extension UINavigationController {
    
    func enableSwipeBack() {
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func disableSwipeBack() {
        interactivePopGestureRecognizer?.isEnabled = false
    }
}
