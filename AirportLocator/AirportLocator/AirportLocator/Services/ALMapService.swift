//
//  ALMapService.swift
//  AirportLocator
//
//  Created by Kishor Pahalwani on 02/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//
import Foundation

class ALMapService {
    
    public func callAPIAirportList(latitude:String,longitude:String,onSuccess successCallback: ((_ list: AirportListModel) -> Void)?, onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        APICallManager.instance.callAPIAirportList(latitude:latitude,longitude:longitude,
            onSuccess: { (list) in
                successCallback?(list)
        },
            onFailure: { (errorMessage) in
                failureCallback?(errorMessage)
        })
    }
}
