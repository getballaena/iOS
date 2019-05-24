//
//  Shape.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 24/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit

class NavigationShape: UINavigationController {
    override func viewDidLoad() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = .white
        self.navigationBar.tintColor = Color.MAINBLUE.getColor()
        self.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}

class TabShape: UITabBarController {
    override func viewDidLoad() {
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = Color.MAINBLUE.getColor()
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.tintColor = .white
    }
}
