//
//  AppearanceSettingsViewController.swift
//  Hit
//
//  Created by Pietro Putelli on 20/10/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class AppearanceSettingsViewController: NavigationBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        navigationBar.dismissImage = Images.SystemIcon.Chevrons.Left
        navigationBar.rightButton.isHidden = true
        navigationBar.delegate = self
        navigationBar.title = "Appearance".uppercased()
        
        isEdgeGesturesEnabled = false
    }
}

extension AppearanceSettingsViewController: BounceViewDelegate {
    func touchesEnded(_ bounceView: BounceView) {
        navigationController?.popViewController(animated: true)
    }
}
