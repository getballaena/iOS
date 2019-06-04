//
//  BoothListVC.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 31/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BoothListVC: UIViewController {
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var myTeamLabel: UILabel!
    @IBOutlet weak var boothList: UITableView!
    
    var viewModel: GameViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.boothList.dataSource = nil
        self.boothList.delegate = nil
        bindViewModel()
    }
    
}

extension BoothListVC{
    func bindViewModel(){
   
        rx.viewWillAppear
            .bind(to: self.viewModel.gameMapReady)
            .disposed(by: self.disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,GameMapModel>>(configureCell:
        { dataSource, tableView, indexPath, data in
            let cell = tableView.dequeueReusableCell(withIdentifier: "BoothCell", for: indexPath) as! BoothCell
            cell.selectionStyle = .none
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
        
        viewModel.boothList
            .drive(self.boothList.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        boothList.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        
        viewModel.endTime
            .drive(onNext: { endTime in
                let date = Date(timeIntervalSince1970: Double(endTime + 32400) )
                let format = DateFormatter()
                format.timeZone = TimeZone(abbreviation: "GMT")
                format.locale = NSLocale.current
                format.dateFormat = "hh:mm a"
                let strDate = format.string(from: date)
                
                self.leftTimeLabel.text = strDate
            })
            .disposed(by: self.disposeBag)
        
        viewModel.teamName
            .drive(self.myTeamLabel.rx.text)
            .disposed(by: self.disposeBag)
        
    }
}

extension BoothListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
}

class BoothCell: UITableViewCell {
    @IBOutlet weak var boothName: UILabel!
    @IBOutlet weak var boothLocation: UILabel!
}
