//
//  GameMapModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 31/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

struct GameMapModel: Codable {
    let boothName: String
    let location: String
    let ownTeam: String
  
    
    enum CodingKeys: String, CodingKey {
        case boothName = "booth_name"
        case location
        case ownTeam = "own_team"
    }
}
