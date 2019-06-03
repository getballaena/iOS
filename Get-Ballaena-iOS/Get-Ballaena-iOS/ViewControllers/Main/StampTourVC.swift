//
//  StampTourVC.swift
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

class StampTourVC: UIViewController {
    @IBOutlet weak var stampList: UITableView!
    @IBOutlet weak var stampCaptureBtn: UIButton!
    @IBOutlet weak var stampTutorialsBtn: tutorialsButtonShape!
    
    var viewModel: StampViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        bindViewModel()
    }
}

extension StampTourVC {
    func bindViewModel() {
        viewModel = StampViewModel()
        
        rx.viewWillAppear
            .bind(to: viewModel.ready)
            .disposed(by: disposeBag)
        
        stampTutorialsBtn.rx.tap
        .bind(to: viewModel.tutorialsDidClicked)
        .disposed(by: disposeBag)
        
        viewModel.tutorialsClickedDone
            .drive(onNext: { isClick in
                if isClick{
                    let alert = UIAlertController(title: "땅따먹기", message:
                        """
                        여기있는 카메라 버튼을 클릭하여
                        각 부스마다 있는 QR코드를
                        촬영하면 스탬프를 획득하는 투어
                        스탬프를 다 획득시 자동으로 쿠폰이 추가됩니다.
                        """, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,StampModel>>(configureCell:
        { datasource, tableView, indexPath, data -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "StampCell", for: indexPath) as! BoothCell
            cell.selectionStyle = .none
            cell.boothName.text = data.boothName
            cell.boothLocation.text = data.location
            cell.layer.borderColor = data.isCaptured ? UIColor.red.cgColor : UIColor.gray.cgColor
            return cell
        })
        
        viewModel.items
            .drive(stampList.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        stampList.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        stampCaptureBtn.rx.tap
            .bind(to: viewModel.captureDidClicked)
            .disposed(by: disposeBag)
        
        viewModel.captureClickDone
            .drive(onNext: { isSuccessed in
                if isSuccessed {
                   let main = UIStoryboard(name: "Main", bundle: nil)
                   let QrCodeReader = main.instantiateViewController(withIdentifier: "QRCodeReader") as! QRCodeReaderVC
                   QrCodeReader.flag.accept("stamp")
                   self.navigationController?.pushViewController(QrCodeReader, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        
    }
}

extension StampTourVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
}


