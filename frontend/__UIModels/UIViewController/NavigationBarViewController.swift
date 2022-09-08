//
//  FullScreenViewController.swift
//  searchBar
//
//  Created by Pietro Putelli on 06/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit
import Motion

class NavigationBarViewController: UIViewController {
    
    lazy var navigationBar = FullScreenNavigationBar()
    
    lazy var leftGesture: UIScreenEdgePanGestureRecognizer = {
        let leftPopEdgeGesture = UIScreenEdgePanGestureRecognizer()
        leftPopEdgeGesture.addTarget(self, action: #selector(popViewControllerGesture1))
        leftPopEdgeGesture.edges = .left
        return leftPopEdgeGesture
    }()
    
    lazy var rightGesture: UIScreenEdgePanGestureRecognizer = {
        let rightPopEdgeGesture = UIScreenEdgePanGestureRecognizer()
        rightPopEdgeGesture.addTarget(self, action: #selector(popViewControllerGesture1))
        rightPopEdgeGesture.edges = .right
        return rightPopEdgeGesture
    }()
    
    var navigationBarHeight: CGFloat {
        return 44 + windowSafeAreaInsets.top
    }
    
    var isEdgeGesturesEnabled: Bool = true {
        didSet {
            leftGesture.isEnabled = isEdgeGesturesEnabled
            rightGesture.isEnabled = isEdgeGesturesEnabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isMotionEnabled = true
        view.addGestureRecognizers(rightGesture,leftGesture)
        
        view.backgroundColor = .mardiGras
        
        view.addSubview(navigationBar)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        NSLayoutConstraint.activate([
            navigationBar.heightAnchor.constraint(equalToConstant: navigationBarHeight),
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func popViewControllerGesture1(_ sender: UIScreenEdgePanGestureRecognizer) {
        motionDismissViewController()
    }
}
