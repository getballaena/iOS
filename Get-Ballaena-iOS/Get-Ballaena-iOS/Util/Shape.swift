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
        self.navigationBar.isHidden = true
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

class tutorialsButtonShape: UIButton {
    override func awakeFromNib() {
        setShape()
    }
    
    func setShape(){
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
    }
}


class toMainButtonShape: UIButton {
    override func awakeFromNib() {
        setShape()
    }
    
    func setShape(){
        layer.borderWidth = 1
        layer.borderColor = Color.MAINBLUE.getColor().cgColor
        layer.cornerRadius = 10
    }
}
