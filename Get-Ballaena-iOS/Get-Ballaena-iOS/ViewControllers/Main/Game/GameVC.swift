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
    @IBOutlet weak var captureBtn: UIButton!
    @IBOutlet weak var gameTutorialsBtn: tutorialsButtonShape!
    
    var viewModel: GameViewModel!
    let disposeBag = DisposeBag()

    let joinTeamVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "joinTeam") as! JoinTeamVC
    let boothListVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "boothList") as! BoothListVC
    let notGameStartedVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "notGameStarted") as! NotStartedGameVC
    
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        viewModel = GameViewModel()
        self.joinTeamVC.viewModel = viewModel
        self.boothListVC.viewModel = viewModel
        bindViewModel()
        delayTimeBind()
    }
    
}

extension GameVC {
    func bindViewModel(){
        rx.viewWillAppear
            .bind(to: viewModel.ready)
            .disposed(by: disposeBag)
        
        gameTutorialsBtn.rx.tap
            .bind(to: viewModel.tutorialsDidClicked)
            .disposed(by: disposeBag)
        
        viewModel.tutorialsClickedDone
            .drive(onNext: { isClick in
                if isClick{
                    let alert = UIAlertController(title: "땅따먹기", message:
                        """
                        여기있는 카메라 버튼을 클릭하여
                        각 부스마다 있는 QR코드를 촬영 후
                        문제를 풀어 맞추면 해당 부스를
                        획득하는 방식의 땅따먹기 게임
                        """, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.teamStatus
            .drive(onNext: { [weak self] isTeamHave in
                guard let `self` = self else { return }
                if !isTeamHave {
                    self.containerView.addSubview(self.joinTeamVC.view)
                } else {
                    self.checkGaming()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.joinTeamIsSuccessed
            .drive(onNext: { [weak self] isJoinSuccess in
                guard let `self` = self else { return }
                if isJoinSuccess{
                    self.showToast(msg: "팀 가입 완료")
                    self.checkGaming()
                    self.viewModel.checkTeamReady.accept(())
                } else {
                    self.showToast(msg: "다시 시도해주세요.")
                }
            })
            .disposed(by: disposeBag)
        
        captureBtn.rx.tap
            .bind(to: viewModel.qrDidClicked)
            .disposed(by: disposeBag)
        
        viewModel.captureClickedDone
            .drive(onNext: { [weak self] isSuccess in
                guard let `self` = self else { return }
                if isSuccess{
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let QrCodeReader = main.instantiateViewController(withIdentifier: "QRCodeReader") as! QRCodeReaderVC
                    QrCodeReader.flag.accept("game")
                    QrCodeReader.gameViewModel = self.viewModel
                    self.navigationController?.pushViewController(QrCodeReader, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func checkGaming(){
        viewModel.checkTeamReady.accept(())
        
        viewModel.gameIsProceeding
            .drive(onNext: { [weak self] statusCode in
                guard let `self` = self else { return }
                switch statusCode{
                case 200:
                    print(statusCode)
                    self.containerView.addSubview(self.boothListVC.view)
                case 408:
                    let alert = UIAlertController(title: "게임 종료", message:
                        "땅따먹기 게임 시간이 만료되었습니다.\n메인 부스로 오셔서 결과를 확인해주세요!"
                        , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.containerView.addSubview(self.notGameStartedVC.view)
                default: self.containerView.addSubview(self.notGameStartedVC.view)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func delayTimeBind(){
        viewModel.delayTime
            .drive(onNext: { [weak self] delay in
                guard let `self` = self else { return }
                switch delay {
                case "": return
                case "team": self.showToast(msg: "이미 우리팀이 점령중입니다.")
                default: self.showToast(msg: "딜레이 : \(delay)")
                }
            })
            .disposed(by: disposeBag)
    }
    
}

