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
    
    var viewModel: StampViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindViewModel()
    }
}

extension StampTourVC {
    func bindViewModel() {
        print("nil")
        viewModel = StampViewModel()
        
        rx.viewWillAppear
            .bind(to: viewModel.ready)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,StampModel>>(configureCell:
        { datasource, tableView, indexPath, data -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "StampCell", for: indexPath) as! BoothCell
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


