//
//  Client.swift
//  Get-Ballaena-iOS
//
//  Created by 조우진 on 24/05/2019.
//  Copyright © 2019 조우진. All rights reserved.
//

import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

protocol ClientType {
    func get(path: String, params: Parameters?, header : Header) -> Observable<(HTTPURLResponse,Data)>
    func post(path: String, params: Parameters?, header : Header) -> Observable<(HTTPURLResponse,Data)>
    
    func delete(path: String, params: Parameters?, header : Header) -> Observable<(HTTPURLResponse,Data)>
}

class Client : ClientType {
    let baseUrl = "http://whale.istruly.sexy:1234/"
    
    func get(path: String, params: Parameters?, header: Header) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.get,
                           baseUrl + path,
                           parameters: params,
                           encoding: URLEncoding.queryString,
                           headers: header.getHeader())
    }
    
    func post(path: String, params: Parameters?, header: Header) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.post,
                           baseUrl + path,
                           parameters: params,
                           encoding: JSONEncoding.default,
                           headers: header.getHeader())
    }
    
    func delete(path: String, params: Parameters?, header: Header) -> Observable<(HTTPURLResponse, Data)> {
        return requestData(.delete,
                           baseUrl + path,
                           parameters: params,
                           encoding: JSONEncoding.default,
                           headers: header.getHeader())
    }
    
}

enum Header {
    case Authorization,Empty
    func getHeader() -> [String : String]? {
        switch self {
        case .Authorization:
            return ["deviceUUID" : UserDefaults.standard.value(forKey: "uuid") as? String ?? "",
                    "Content-Type" : "application/json"]
        case .Empty :
            return ["Content-Type" : "application/json"]
        }
    }
}

enum StatusCode {
    case success, failure
}
