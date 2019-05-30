//
//  GamePath.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 29/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

enum GamePath: API {
    
    case map, solve(boothName: String)
    
    func Path() -> String {
        switch self {
        case .map: return "map"
        case .solve(let boothName): return "solve/\(boothName)"
        }
    }
    
}
