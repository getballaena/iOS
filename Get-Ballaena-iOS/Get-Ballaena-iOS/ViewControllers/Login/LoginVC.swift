//
//  ViewController.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 23/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    var viewModel: LoginViewModel!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(UIDevice.current.identifierForVendor!.uuidString.lowercased(), forKey: "uuid")
        bindViewModel()
    }
    
}

extension LoginVC {
    func bindViewModel(){
        viewModel = LoginViewModel()
        
        viewModel.uuid.accept(UserDefaults.standard.value(forKey: "uuid") as! String)
        
        usernameInput.rx.text
            .orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        registerBtn.rx.tap
            .bind(to: viewModel.registerDidClicked)
            .disposed(by: disposeBag)
        
        viewModel.checkDone
            .drive(onNext: { isSuccessed in
                if isSuccessed {
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                }
            })
        .disposed(by: disposeBag)
        
        viewModel.registerDone
            .drive(onNext: { isSuccessed in
                if isSuccessed {
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                } else {
                    self.showToast(msg: "잠시후 다시 시도해주세요.")
                }
            })
        .disposed(by: disposeBag)
        
    }
}

