//
//  extensions.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 23/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
