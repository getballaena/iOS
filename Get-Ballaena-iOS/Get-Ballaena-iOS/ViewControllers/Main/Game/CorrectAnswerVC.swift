//
//  CorrectVC.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 02/06/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CorrectAnswerVC: UIViewController {
    @IBOutlet weak var toMainBtn: UIButton!
    
    var viewModel = GameViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindViewModel()
    }
}

extension CorrectAnswerVC {
    func bindViewModel(){
        
        toMainBtn.rx.tap
        .bind(to: viewModel.toMainDidClicked)
        .disposed(by: disposeBag)
        
        viewModel.toMainDone
            .drive(onNext: { [weak self] isClick in
                if isClick{
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.viewModel.gameMapReady.accept(())
                }
            })
        .disposed(by: disposeBag)
    
    }
}
