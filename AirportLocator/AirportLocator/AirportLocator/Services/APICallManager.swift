//
//  APICallManager.swift
//  AirportLocator
//
//  Created by Kishor Pahalwani on 02/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//
import Alamofire
import SwiftyJSON
import Foundation

let API_BASE_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/"
let key = "AIzaSyD5tL9LV8fcYTla86EAMMxO5Lo4YNyb6fk"

class APICallManager {
    static let instance = APICallManager()
    
    enum RequestMethod {
        case get
        case post
    }
    
    // MARK: POST RATE CONVERTER API
    func callAPIAirportList(latitude:String,longitude:String,onSuccess successCallback: ((_ list: AirportListModel) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        
        // Build URL
        let url = API_BASE_URL + "json?location=" + latitude + "," + longitude + "&radius=5000&keyword=airport&key=" + key
        
        // Build Headers
        let airportListHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        
        // call API
        self.createRequest(
            url, method: .get, headers: airportListHeaders, parameters: nil,
            onSuccess: {(responseObject: JSON) -> Void in
                // Create dictionary
                if let responseDict = responseObject.dictionaryObject {
                    let listDict = responseDict as [String : AnyObject]
                    let data =  AirportListModel.build(listDict)
                   
                    // Fire callback
                    successCallback?(data)
                } else {
                    failureCallback?("An error has occured.")
                }
        },
            onFailure: {(errorMessage: String) -> Void in
                failureCallback?(errorMessage)
        }
        )
    }
    
    // MARK: Request Handler
    // Create request
    func createRequest(
        _ url: String,
        method: HTTPMethod,
        headers: HTTPHeaders,
        parameters: Parameters? = nil,
        onSuccess successCallback: ((JSON) -> Void)?,
        onFailure failureCallback: ((String) -> Void)?
        ) {
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                successCallback?(json)
            case .failure(let error):
                if let callback = failureCallback {
                    // Return
                    callback(error.localizedDescription)
                }
            }
        }
    }
}
