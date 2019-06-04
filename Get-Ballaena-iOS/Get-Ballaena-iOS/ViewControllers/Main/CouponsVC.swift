//
//  CouponsVC.swift
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

class CouponsVC: UIViewController {
    @IBOutlet weak var couponList: UITableView!
    
    var viewModel: CouponsViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        bindViewModel()
        couponList.separatorStyle = .none
    }
    
}

extension CouponsVC {
    func bindViewModel(){
        viewModel = CouponsViewModel()
        
        rx.viewWillAppear
            .bind(to: viewModel.ready)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CouponModel>>(configureCell:
        { dataSource, tableview, index, data in
            let cell = tableview.dequeueReusableCell(withIdentifier: "CouponCell", for: index) as! CouponCell
            cell.selectionStyle = .none
            cell.couponName.text = data.couponName
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
        })
        
        viewModel.couponList
            .drive(couponList.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        couponList.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        couponList.rx.itemSelected
            .bind(to: viewModel.cellSelected)
            .disposed(by: disposeBag)
        
        viewModel.selectedDone
            .drive(onNext: { isSuccessed in
                if isSuccessed {
                    let alert = UIAlertController(title: "쿠폰 사용", message: "", preferredStyle: .alert)
                    
                    alert.addTextField(configurationHandler: { [weak self] textfield in
                        guard let `self` = self else { return }
                        textfield.placeholder = "직원 코드를 입력해주세요."
                        
                        textfield.rx.text
                            .orEmpty
                            .bind(to: self.viewModel.adminID)
                            .disposed(by: self.disposeBag)
                    })
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        self.viewModel.couponUseDidClicked.accept(())
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.couponUsed
            .drive(onNext: {[weak self] status in
                guard let `self` = self else { return }
                switch status{
                case 200:
                    self.viewModel.ready.accept(())
                    
                    self.showToast(msg: "성공적으로 사용되었습니다.")
                    
                default: return
                }
            }).disposed(by: disposeBag)
        
        
    }
}

extension CouponsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
}

class CouponCell: UITableViewCell{
    @IBOutlet weak var couponName: UILabel!
}


