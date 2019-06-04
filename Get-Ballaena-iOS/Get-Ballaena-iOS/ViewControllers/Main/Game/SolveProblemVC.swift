//
//  SovleProblemVC.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 02/06/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SolveProblemVC: UIViewController {
    @IBOutlet weak var boothName: UILabel!
    @IBOutlet weak var problemContent: UILabel!
    @IBOutlet weak var answerList: UITableView!
    
    var answers: [SectionModel<String,String>] = []
    var viewModel = GameViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        bindViewModel()
    }
}

extension SolveProblemVC{
    func bindViewModel(){
        viewModel.qrDidDone
            .drive(onNext: { [weak self] status, data in
                guard let `self` = self else { return }
                
                if status == 200{
                    guard let response = try? JSONDecoder().decode(ProblemModel.self, from: data) else { return }
                    self.boothName.text = response.boothName
                    self.problemContent.text = response.content
                    self.viewModel.problemID.accept(response.problemId)
                    
                    for i in response.choices.indices {
                        self.answers.append(SectionModel<String,String>(model: "", items: [response.choices[i]]))
                    }
                    
                    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell:
                    { dataSource, tableView, indexPath, data in
                        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! AnswerCell
                        cell.answer.text = data
                        cell.layer.borderColor = Color.MAINBLUE.getColor().cgColor
                        return cell
                    })
                    
                    Observable.just(self.answers)
                        .bind(to: self.answerList.rx.items(dataSource: dataSource))
                        .disposed(by: self.disposeBag)
                    
                } else {
                    
                }
            })
            .disposed(by: disposeBag)
        
        answerList.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        answerList.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.answer.accept(self?.answers[indexPath.section].items[0] ?? "")
            })
            .disposed(by: disposeBag)
        
        viewModel.isCorrect
            .drive(onNext: { [weak self] res in
                guard let `self` = self else { return }
                switch res{
                case "정답":
                    let correctVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "CorrectVC") as! CorrectAnswerVC
                    correctVC.viewModel = self.viewModel
                    self.performSegue(withIdentifier: "toCorrect", sender: nil)
                case "오답":
                    let wrongVC = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "WrongVC") as! WrongAnswerVC
                    wrongVC.viewModel = self.viewModel
                    self.performSegue(withIdentifier: "toWrong", sender: nil)
                case "": return
                default: self.showToast(msg: "딜레이 : \(res)")
                }
            })
            .disposed(by: disposeBag)
        
    }
}

extension SolveProblemVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
}

class AnswerCell: UITableViewCell {
    @IBOutlet weak var answer: UILabel!
}
