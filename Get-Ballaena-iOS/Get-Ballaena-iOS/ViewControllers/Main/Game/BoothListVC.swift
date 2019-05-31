//
//  BoothListVC.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 31/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit

class BoothListVC: UIViewController {
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var myTeamLabel: UILabel!
    @IBOutlet weak var boothList: UITableView!
    
    override func viewDidLoad() {
        self.boothList.dataSource = nil
        self.boothList.delegate = nil
    }
}

class BoothCell: UITableViewCell {
    @IBOutlet weak var boothName: UILabel!
    @IBOutlet weak var boothLocation: UILabel!
}
