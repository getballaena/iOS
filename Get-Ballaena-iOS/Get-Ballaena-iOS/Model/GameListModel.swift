//
//  GameMapModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 31/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

struct GameListModel: Codable {
    let endTimeTimestamp: Int
    let map: [GameMapModel]
    let myTeam: String
    
    
}
