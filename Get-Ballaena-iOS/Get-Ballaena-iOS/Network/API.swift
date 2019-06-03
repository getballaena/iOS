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
    func stampMap() -> Observable<(Int, Data)>
    func captureStamp(stampName: String) -> Observable<Int>
}

protocol Game {
    func teamCheck() -> Observable<Int>
    func joinTeam(teamCode: String) -> Observable<Int>
    func gameMap() -> Observable<(Int,Data)>
    func gameProblems(boothName: String) -> Observable<(Int,Data)>
    func solveProblem(boothName: String, problemId: String, answer: String) -> Observable<(Int,Data)>
}

protocol Coupons {
    func couponList() -> Observable<[CouponModel]>
    func couponUse(couponId: String, staffCode: String) -> Observable<Int>
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
    func stampMap() -> Observable<(Int, Data)> {
        return client.get(path: StampPath.stampmap.Path(),
                          params: nil,
                          header: Header.Authorization)
            .map { res, data -> (Int, Data) in
                return (res.statusCode, data)
            }
    }
    
    func captureStamp(stampName: String) -> Observable<Int> {
        return client.post(path: StampPath.stamp.Path(),
                           params: ["stampName" : stampName],
                           header: Header.Authorization)
            .map { res, data -> Int in
                return res.statusCode
            }
    }
}

class GameApi: Game {
    func teamCheck() -> Observable<Int> {
        return client.get(path: TeamPath.check.Path(),
                          params: nil,
                          header: Header.Authorization)
            .map { res, data  -> Int in
                    return res.statusCode
                }
        }
    
    func joinTeam(teamCode: String) -> Observable<Int> {
        return client.post(path: TeamPath.team.Path(),
                           params: ["joinCode" : teamCode],
                           header: Header.Authorization)
            .map { res, data  -> Int in
                return res.statusCode
        }
    }
    
    func gameMap() -> Observable<(Int, Data)> {
        return client.get(path: GamePath.map.Path(),
                          params: nil,
                          header: Header.Authorization)
            .map { res, data -> (Int,Data) in
                return (res.statusCode, data)
        }
    }
    
    func gameProblems(boothName: String) -> Observable<(Int, Data)> {
        return client.get(path: GamePath.solve(boothName: boothName).Path(),
                          params: nil,
                          header: Header.Authorization)
            .map { res, data -> (Int, Data) in
                return (res.statusCode, data)
        }
    }
    
    func solveProblem(boothName: String, problemId: String, answer: String) -> Observable<(Int,Data)> {
        return client.post(path: GamePath.solve(boothName: boothName).Path(),
                           params: ["problemId" : problemId,
                                    "answer" : answer],
                           header: Header.Authorization)
            .map { res, data -> (Int,Data) in
                return (res.statusCode, data)
        }
    }
}
    

    class CouponsApi: Coupons {
        func couponList() -> Observable<[CouponModel]> {
            return client.get(path: CouponPath.coupon.Path(),
                              params: nil,
                              header: Header.Authorization)
                .map { res, data -> [CouponModel] in
                    switch res.statusCode {
                    case 200:
                        guard let response = try? JSONDecoder().decode([CouponModel].self, from: data) else {
                            return []
                        }
                        return response
                    case 404: return []
                    default: return []
                    }
            }
        }
        
        func couponUse(couponId: String, staffCode: String) -> Observable<Int> {
            return client.delete(path: CouponPath.coupon.Path(),
                                 params: ["couponId" : couponId,
                                          "staffCode" : staffCode],
                                 header: Header.Authorization)
                .map { res, data -> Int in
                    return res.statusCode
            }
        }
        
}
