//
//  StampViewModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 31/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class StampViewModel {
    //Input
    let ready = PublishRelay<Void>()
    let captureDidClicked = PublishRelay<Void>()
    let qrBoothName = BehaviorRelay<String>(value: "")
    let tutorialsDidClicked = PublishRelay<Void>()
    
    //Output
    let items: Driver<[SectionModel<String,StampModel>]>
    let captureClickDone: Driver<Bool>
    let qrDidDone: Driver<Bool>
    let tutorialsClickedDone: Driver<Bool>
    
    init() {
        let api = StampApi()
        
        self.items = ready.asObservable()
            .flatMap { api.stampMap() }
            .map { status, data -> [SectionModel<String,StampModel>] in
                switch status{
                case 200:
                    var items: [SectionModel<String,StampModel>] = []
                    guard let response = try? JSONDecoder().decode([StampModel].self, from: data) else {
                        return []
                    }
                    for i in response.indices {
                        items.append(SectionModel<String,StampModel>(model: "", items: [response[i]]))
                    }
                    return items
                default:
                    return []
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        self.captureClickDone = captureDidClicked.asObservable()
            .map { return true }
            .asDriver(onErrorJustReturn: false)
        
        self.qrDidDone = qrBoothName.asObservable()
            .flatMapLatest { api.captureStamp(stampName: $0) }
            .map { status -> Bool in
                switch status{
                case 200: return true
                default:
                    return false
                }
            }
            .asDriver(onErrorJustReturn: false)
        
        self.tutorialsClickedDone = tutorialsDidClicked.asObservable()
            .map { return true }
            .asDriver(onErrorJustReturn: false)
        
    }
}
