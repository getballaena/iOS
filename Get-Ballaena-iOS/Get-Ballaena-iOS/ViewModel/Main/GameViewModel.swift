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
    let qrDidClicked = PublishRelay<Void>()
    let qrBoothName = BehaviorRelay<String>(value: "")
    let answer = PublishRelay<String>()
    let problemID = BehaviorRelay<String>(value: "")
    let toMainDidClicked = PublishRelay<Void>()
    let tutorialsDidClicked = PublishRelay<Void>()
    
    //Output
    let teamStatus: Driver<Bool>
    let joinTeamIsSuccessed: Driver<Bool>
    let gameIsProceeding : Driver<Int>
    let boothList: Driver<[SectionModel<String,GameMapModel>]>
    let teamName: Driver<String>
    let endTime: Driver<Int>
    let captureClickedDone: Driver<Bool>
    let qrDidDone: Driver<(Int,Data)>
    let isCorrect: Driver<String>
    let toMainDone: Driver<Bool>
    let tutorialsClickedDone: Driver<Bool>
    
    init() {
        let api = GameApi()
        let endTime = BehaviorRelay<Int>(value: 0)
        let teamName = BehaviorRelay<String>(value: "")
        
        self.teamStatus = ready.asObservable()
            .flatMapLatest { api.teamCheck() }
            .map { status -> Bool in
                switch status{
                case 200:
                    return true
                default:
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
                    return false
                }
            }
            .asDriver(onErrorJustReturn: false)
        
        self.gameIsProceeding = ready.asObservable()
            .flatMapLatest { api.gameMap() }
            .map { status, _  -> Int in
                return status
            }
            .asDriver(onErrorJustReturn: 0)
        
        self.boothList = gameMapReady.asObservable()
            .flatMapLatest { api.gameMap() }
            .map { status, data -> [SectionModel<String,GameMapModel>] in
                guard let response = try? JSONDecoder().decode(GameListModel.self, from: data) else {
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
        self.endTime = endTime.asDriver(onErrorJustReturn: 0)
        
        self.captureClickedDone = qrDidClicked.asObservable()
            .map { return true }
            .asDriver(onErrorJustReturn: false)
        
        self.qrDidDone = qrBoothName.asObservable()
            .flatMap { api.gameProblems(boothName: $0) }
            .map { status, data in
                return (status,data)
            }
            .asDriver(onErrorJustReturn: (0,Data()))
        
        self.isCorrect = BehaviorRelay.combineLatest(qrBoothName,answer, problemID) { ($0, $1, $2) }
            .flatMapLatest { pair -> Observable<(Int,Data)> in
                let (booth,answer,id) = pair
                return api.solveProblem(boothName: booth, problemId: id, answer: answer) }
            .map { status, data -> String in
                switch status{
                case 201: return "정답"
                case 205: return "오답"
                case 409:
                    guard let response = try? JSONDecoder().decode(DelayModel.self, from: data) else{
                        return ""
                    }
                    return response.delayTime
                default: return ""
                }
            }
            .asDriver(onErrorJustReturn: "")
        
        self.toMainDone = toMainDidClicked.asObservable()
            .map { return true }
            .asDriver(onErrorJustReturn: false)
        
        self.tutorialsClickedDone = tutorialsDidClicked.asObservable()
            .map { return true }
            .asDriver(onErrorJustReturn: false)
    }
}

