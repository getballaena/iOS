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
    case MAINBLUE, HUMPBACKWHALE, MINKWHALE, GREATWHALE

    func getColor() -> UIColor {
        switch self {
        case .MAINBLUE: return UIColor(red: 98/255, green: 185/255, blue: 211/255, alpha: 1)
        case .HUMPBACKWHALE: return UIColor(red: 237/255, green: 100/255, blue: 95/255, alpha: 1)
        case .MINKWHALE: return UIColor(red: 101/255, green: 190/255, blue: 86/255, alpha: 1)
        case .GREATWHALE: return UIColor(red: 79/255, green: 84/255, blue: 237/255, alpha: 1)
        }
    }
}
