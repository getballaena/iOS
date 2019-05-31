//
//  GameVC.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 24/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class GameVC: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    var viewModel: GameViewModel!
    let disposeBag = DisposeBag()
    
    let joinTeamVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "joinTeam") as! JoinTeamVC
    let boothListVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "boothList") as! BoothListVC
    let notGameStartedVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "notGameStarted") as! NotStartedGameVC
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        viewModel = GameViewModel()
        bindViewModel()
    }
}

extension GameVC {
    func bindViewModel(){
        rx.viewWillAppear
            .bind(to: viewModel.ready)
            .disposed(by: disposeBag)
        
        viewModel.teamStatus
            .drive(onNext: { [weak self] isTeamHave in
                print(isTeamHave)
                guard let `self` = self else { return }
                if isTeamHave {
                    self.boothListBind()
                } else {
                    self.containerView.addSubview(self.joinTeamVC.view)
                    
                    self.joinTeamVC.joinTeamCodeInput.rx.text
                        .orEmpty
                        .bind(to: self.viewModel.teamCode)
                        .disposed(by: self.disposeBag)
                    
                    self.joinTeamVC.joinTeamBtn.rx.tap
                        .bind(to: self.viewModel.joinTeamDidClicked)
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        
        viewModel.joinTeamIsSuccessed
            .drive(onNext: { [weak self] isJoinSuccess in
                guard let `self` = self else { return }
                if isJoinSuccess{
                    self.showToast(msg: "팀 가입 완료")
                    self.boothListBind()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func boothListBind(){
        viewModel.gameMapReady.accept(())
        
        viewModel.gameIsProceeding
            .drive(onNext: { [weak self] isGaming in
                guard let `self` = self else { return }
                print(isGaming)
                if isGaming {
                    self.containerView.addSubview(self.boothListVC.view)
                    
                    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,GameMapModel>>(configureCell:
                    { dataSource, tableView, indexPath, data in
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BoothCell", for: indexPath) as! BoothCell
                        cell.boothName.text = data.boothName
                        cell.boothLocation.text = data.location
                        switch data.ownTeam {
                        case "밍크고래팀":
                            cell.layer.borderColor = Color.MINKWHALE.getColor().cgColor
                        case "혹등고래팀":
                            cell.layer.borderColor = Color.HUMPBACKWHALE.getColor().cgColor
                        case "대왕고래팀":
                            cell.layer.borderColor = Color.GREATWHALE.getColor().cgColor
                        default:
                            cell.layer.borderColor = UIColor.gray.cgColor
                        }
                        return cell
                    })
                    
                    self.boothListVC.rx.viewWillAppear
                        .bind(to: self.viewModel.gameMapReady)
                        .disposed(by: self.disposeBag)
                    
                    self.viewModel.boothList
                        .drive(self.boothListVC.boothList.rx.items(dataSource: dataSource))
                        .disposed(by: self.disposeBag)
                    
                    self.viewModel.endTime
                        .drive(self.boothListVC.leftTimeLabel.rx.text)
                        .disposed(by: self.disposeBag)
                    
                    self.viewModel.teamName
                        .drive(self.boothListVC.myTeamLabel.rx.text)
                        .disposed(by: self.disposeBag)
                    
                } else {
                    self.containerView.addSubview(self.notGameStartedVC.view)
                }
            })
            .disposed(by: self.disposeBag)
        
    }
}
