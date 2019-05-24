//
//  Colors.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 24/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit

enum Color {
    case MAINBLUE
    
    func getColor() -> UIColor {
        switch self {
        case .MAINBLUE: return UIColor(red: 98/255, green: 185/255, blue: 211/255, alpha: 1)
        }
    }
}
