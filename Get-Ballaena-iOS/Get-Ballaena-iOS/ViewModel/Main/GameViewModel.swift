//
//  GameViewModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 31/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class GameViewModel  {
    //Input
    let ready = PublishRelay<Void>()
    let teamCode = BehaviorRelay<String>(value: "")
    let joinTeamDidClicked = PublishRelay<Void>()
    let gameMapReady = PublishRelay<Void>()
    
    //Output
    let teamStatus: Driver<Bool>
    let joinTeamIsSuccessed: Driver<Bool>
    let gameIsProceeding : Driver<Bool>
    let boothList: Driver<[SectionModel<String,GameMapModel>]>
    let teamName: Driver<String>
    let endTime: Driver<String>
    
    init() {
        let api = GameApi()
        let endTime = BehaviorRelay<String>(value: "")
        let teamName = BehaviorRelay<String>(value: "")

        self.teamStatus = ready.asObservable()
            .flatMapLatest { api.teamCheck() }
            .map { status -> Bool in
                switch status{
                case 200:
                    return true
                default:
                    print(status)
                    return false
                }
            }.asDriver(onErrorJustReturn: false)
        
        self.joinTeamIsSuccessed = joinTeamDidClicked.asObservable()
            .withLatestFrom(teamCode.asObservable())
            .flatMapLatest { api.joinTeam(teamCode: $0) }
            .map { status -> Bool in
                switch status{
                case 201: return true
                default:
                    print(status)
                    return false
                }
            }
            .asDriver(onErrorJustReturn: false)
        
        self.gameIsProceeding = ready.asObservable()
            .flatMapLatest { api.gameMap() }
            .map { status, _  -> Bool in
                switch status{
                case 200: return true
                default:
                    print("proceeding \(status)")
                    return false
                }
            }
            .asDriver(onErrorJustReturn: false)
        
        self.boothList = gameMapReady.asObservable()
            .flatMapLatest { api.gameMap() }
            .map { status, data -> [SectionModel<String,GameMapModel>] in
                print("boothList \(status)")
                guard let response = try? JSONDecoder().decode(GameListModel.self, from: data) else {
                    print("decode fail")
                    return []
                }
                
                endTime.accept(response.endTimeTimestamp)
                teamName.accept(response.myTeam)
                
                var items: [SectionModel<String,GameMapModel>] = []
                
                for i in response.map.indices {
                    items.append(SectionModel<String,GameMapModel>(model: "", items: [response.map[i]]) )
                }
                return items
            }
            .asDriver(onErrorJustReturn: [])
        
       self.teamName = teamName.asDriver(onErrorJustReturn: "")
       self.endTime = endTime.asDriver(onErrorJustReturn: "")
    }
}
