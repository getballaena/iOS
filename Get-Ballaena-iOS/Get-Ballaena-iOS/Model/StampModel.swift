//
//  StampModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 31/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

struct StampModel: Codable {
    let isCaptured: Bool
    let location: String
    let boothName: String
    
    enum CodingKeys: String, CodingKey {
        case isCaptured = "is_captured"
        case location
        case boothName = "name"
    }
}
