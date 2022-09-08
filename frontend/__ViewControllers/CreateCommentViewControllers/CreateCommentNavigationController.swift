//
//  CreateCommentNavigationController.swift
//  Hit
//
//  Created by Pietro Putelli on 29/08/2020.
//  Copyright © 2020 Pietro Putelli. All rights reserved.
//

import UIKit

class CreateCommentNavigationController: InteractivePopDismissNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [CreateCommentViewController()]
    }
}
