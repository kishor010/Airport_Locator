//
//  NetworkRouter.swift
//  AirportLocator
//
//  Created by Kishor Pahalwani on 02/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation

private let requestTimeOut: TimeInterval = 60

class NetworkRouter {
    
    enum Router {
        
        //MARK:- Case
        case getCompaniesList
        
        //MARK:- HTTP Method
        var method: String {
            switch self {
            case .getCompaniesList:
                return "POST"
            }
        }
        
        //MARK: Base URL
        var baseUrl: String {
            return "https://next.json-generator.com/api/json/get/Vk-LhK44U"
        }
    
        //Method URLRequest
        func asURLRequest() -> URLRequest? {
            if let url =  URL(string: baseUrl) {
                var urlRequest = URLRequest(url:url)
                urlRequest.httpMethod = method
                urlRequest.timeoutInterval = requestTimeOut
                urlRequest.allowsCellularAccess = true
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                return urlRequest
            }
                
            else {
                return nil
            }
        }
    }
}





