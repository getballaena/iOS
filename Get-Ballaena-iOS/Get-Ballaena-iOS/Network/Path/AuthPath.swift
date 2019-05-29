//
//  AuthApi.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 24/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

enum AuthPath: API{
    
    case auth(uuid: String)
    
    func Path() -> String {
        switch self {
        case .auth(let uuid): return "auth/\(uuid)"
        }
    }
    
}
