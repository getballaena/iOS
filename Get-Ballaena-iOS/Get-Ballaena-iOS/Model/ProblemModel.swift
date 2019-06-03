//
//  ProblemModel.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 02/06/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Foundation

struct ProblemModel: Codable {
    let boothName: String
    let choices: [String]
    let content: String
    let problemId: String
}
