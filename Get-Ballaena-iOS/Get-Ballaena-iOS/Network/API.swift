//
//  API.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 24/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol Auth {
    func checkUUID(uuid: String) -> Observable<Int>
    func registerUUID(uuid: String, name: String) -> Observable<Int>
}

protocol Stamp {
    
}

protocol Game {
    
}

protocol Coupons {
    
}

private let client = Client()

class AuthApi: Auth {
    func checkUUID(uuid: String) -> Observable<Int> {
        return client.get(path: AuthPath.auth(uuid: uuid).Path(),
                          params: nil,
                          header: Header.Empty)
            .map { res, data -> Int in
                return res.statusCode
            }
    }
    
    func registerUUID(uuid: String, name: String) -> Observable<Int> {
        return client.post(path: AuthPath.auth(uuid: uuid).Path(),
                           params: ["name" : name],
                           header: Header.Empty)
            .map { res, data -> Int in
                return res.statusCode
            }
    }
}

class StampApi: Stamp {
    
}

class GameApi: Game {
    
}

class CouponsApi: Coupons {
    
}
