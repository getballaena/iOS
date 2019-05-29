//
//  StampPath.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 24/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

enum StampPath: API{
    
    case stampmap,stamp
    
    func Path() -> String {
        switch self {
        case .stamp: return "stamp"
        case .stampmap: return "stamp/map"
        }
    }
    
}
