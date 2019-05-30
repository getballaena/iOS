//
//  CouponsViewModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 29/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class CouponsViewModel {
    
    //Input
    let ready = PublishRelay<Void>()
    let cellSelected = BehaviorRelay<IndexPath>(value: IndexPath(row: 0, section: 0))
    let adminID = BehaviorRelay<String>(value: "")
    let couponUseDidClicked = PublishRelay<Void>()
    
    //Output
    let couponList: Driver<[SectionModel<String,CouponModel>]>
    let selectedDone: Driver<Bool>
    let couponUsed: Driver<Int>
    
    init() {
        let api = CouponsApi()
        
        self.couponList = ready.asObservable()
            .flatMapLatest{ _ in api.couponList() }
            .map { items -> [SectionModel<String,CouponModel>] in
                var datas: [SectionModel<String,CouponModel>] = []
                for i in items.indices{
                    datas.append(SectionModel<String,CouponModel>(model: "", items: [items[i]]))
                }
                return datas
            }
            .asDriver(onErrorJustReturn: [])
        
        self.selectedDone = cellSelected.asObservable()
            .map { _ in return true }
            .asDriver(onErrorJustReturn: false)
        
        let couponID = cellSelected.asObservable()
            .withLatestFrom(couponList.asObservable()) { indexpath, datas in
                return datas[indexpath.row].items[indexpath.row]
            }
            .map { return $0.couponID }
        
        
        let CouponIDWithAdminID = Observable.combineLatest(couponID, adminID.asObservable()) { ($0, $1) }
        
        self.couponUsed = couponUseDidClicked.asObservable()
            .withLatestFrom(CouponIDWithAdminID)
            .flatMapLatest { api.couponUse(couponId: $0, staffCode: $1) }
            .map { return $0 }
            .asDriver(onErrorJustReturn: 0)
    }
}
