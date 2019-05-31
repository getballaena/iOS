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
    
    //Output
    let items: Driver<[SectionModel<String,StampModel>]>
    
    init() {
        let api = StampApi()
        
        self.items = ready.asObservable()
            .flatMap { api.stampMap() }
            .map { status, data -> [SectionModel<String,StampModel>] in
                switch status{
                case 200:
                    var items: [SectionModel<String,StampModel>] = []
                    guard let response = try? JSONDecoder().decode([StampModel].self, from: data) else {
                        print("decode fail")
                        return []
                    }
                    for i in response.indices {
                        items.append(SectionModel<String,StampModel>(model: "", items: [response[i]]))
                    }
                    print(response)
                    return items
                default:
                    return []
                }
        }
        .asDriver(onErrorJustReturn: [])
    }
}
