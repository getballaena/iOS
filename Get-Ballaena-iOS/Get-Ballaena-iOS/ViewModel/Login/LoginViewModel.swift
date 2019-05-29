//
//  LoginViewModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 29/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    //Input
    let uuid = BehaviorRelay<String>(value: "")
    let username = BehaviorRelay<String>(value: "")
    let registerDidClicked = PublishRelay<Void>()
    
    //Output
    let checkDone: Driver<Bool>
    let registerDone: Driver<Bool>
    
    init() {
        let api = AuthApi()
        let UUIDWithUserName = BehaviorRelay.combineLatest(uuid, username) { ($0, $1) }
        
        self.checkDone = uuid.asObservable()
            .flatMapLatest{
                api.checkUUID(uuid: $0)
            }
            .map { status -> Bool in
                switch status{
                case 200: return true
                case 204: return false
                default: return false
                }
            }
            .asDriver(onErrorJustReturn: false)
        
        self.registerDone = registerDidClicked.asObservable()
            .withLatestFrom(UUIDWithUserName)
            .flatMapLatest {
                api.registerUUID(uuid: $0, name: $1)
            }
            .map { status -> Bool in
                switch status{
                case 201: return true
                case 205: return false
                default: return false
                }
            }
            .asDriver(onErrorJustReturn: false)
    }
}
