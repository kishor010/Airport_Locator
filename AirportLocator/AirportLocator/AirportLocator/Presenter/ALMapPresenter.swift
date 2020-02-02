//
//  ALMapPresenter.swift
//  AirportLocator
//
//  Created by Kishor Pahalwani on 02/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation

protocol MapControllerView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func showError(errorMessage: String)
    func onSuccess(list: AirportListModel)
}

class ALMapPresenter {
    private let alMapService:ALMapService
    weak private var mapControllerView : MapControllerView?
    
    init(alMapService:ALMapService) {
        self.alMapService = alMapService
    }
    
    func attachView(view:MapControllerView) {
        mapControllerView = view
    }
    
    func detachView() {
        mapControllerView = nil
    }
    
    func airportListAPI(latitude:String,longitude:String) {
        self.mapControllerView?.startLoading()
        alMapService.callAPIAirportList(latitude:latitude,longitude:longitude,
            onSuccess: { (lists) in
                DispatchQueue.main.async {
                    self.mapControllerView?.finishLoading()
                    self.mapControllerView?.onSuccess(list: lists)
                }
        },
            onFailure: { (errorMessage) in
                DispatchQueue.main.async {
                    self.mapControllerView?.finishLoading()
                    self.mapControllerView?.showError(errorMessage: errorMessage)
                }
        })
    }
}
