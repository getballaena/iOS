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
    let captureStatus = PublishRelay<Int>()
    let dealyTime = PublishRelay<String>()
    
    let joinTeamVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "joinTeam") as! JoinTeamVC
    let boothListVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "boothList") as! BoothListVC
    let notGameStartedVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "notGameStarted") as! NotStartedGameVC
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        viewModel = GameViewModel()
        self.joinTeamVC.viewModel = viewModel
        self.boothListVC.viewModel = viewModel
        bindViewModel()
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
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.joinTeamIsSuccessed
            .drive(onNext: { [weak self] isJoinSuccess in
                guard let `self` = self else { return }
                if isJoinSuccess{
                    self.containerView.addSubview(self.boothListVC.view)
                    self.boothListVC.showToast(msg: "팀 가입 완료")
                } else {
                    self.showToast(msg: "다시 시도해주세요.")
                }
            })
            .disposed(by: disposeBag)
        
        captureBtn.rx.tap
            .bind(to: viewModel.qrDidClicked)
            .disposed(by: disposeBag)
        
        viewModel.captureClickedDone
            .drive(onNext: { isSuccess in
                if isSuccess{
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let QrCodeReader = main.instantiateViewController(withIdentifier: "QRCodeReader") as! QRCodeReaderVC
                    QrCodeReader.flag.accept("game")
                    self.navigationController?.pushViewController(QrCodeReader, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.gameIsProceeding
            .drive(onNext: { [weak self] statusCode in
                guard let `self` = self else { return }
                switch statusCode{
                case 200: self.containerView.addSubview(self.boothListVC.view)
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
            .disposed(by: self.disposeBag)
        
        dealyTime.asObservable()
            .subscribe(onNext: { status in
                if status != "이미 우리팀이 점령중입니다." {
                    self.showToast(msg: "남은 시간 : \(status)")
                } else {
                    self.showToast(msg: "\(status)")
                }
            })
        .disposed(by: disposeBag)
    }
}

