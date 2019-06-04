//
//  JoinTeamVC.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 30/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class JoinTeamVC: UIViewController {
    @IBOutlet weak var joinTeamCodeInput: UITextField!
    @IBOutlet weak var joinTeamBtn: UIButton!
    
    var viewModel = GameViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindViewModel()
    }
}

extension JoinTeamVC{
    func bindViewModel(){
        
        joinTeamCodeInput.rx.text
            .orEmpty
            .bind(to: viewModel.teamCode)
            .disposed(by: disposeBag)
        
        joinTeamBtn.rx.tap
            .debounce(0.3, scheduler: MainScheduler.instance)
            .bind(to: viewModel.joinTeamDidClicked)
            .disposed(by: disposeBag)
        
    }
}
