//
//  CouponPath.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 29/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

enum CouponPath: API {
    
    case coupon
    
    func Path() -> String {
        switch self {
        case .coupon: return "coupon"
        }
    }
    
}
