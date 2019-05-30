//
//  CouponModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 29/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

struct CouponModel : Codable {
    let couponID: String
    let couponName: String
    
    enum CodingKeys: String,CodingKey{
        case couponID = "coupon_id"
        case couponName = "coupon_name"
    }
}
