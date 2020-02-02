//
//  AirportListModel.swift
//  AirportLocator
//
//  Created by Kishor Pahalwani on 02/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//
import Foundation

struct AirportListModel {
    
    var status    : String?
    var isSuccess : Bool?
    var results   : [AirportsList] = []
    
    
    mutating func parseAirportListResponse(response: Dictionary<String, Any>) {
        print(#function)
        print(response)
        
        if let status = response["status"] as? String, status == "OK" {
            self.isSuccess = true
            self.status = status
            
            if let List = response["results"] as? NSArray {
                for Item in List {
                    var airportsListData: AirportsList = AirportsList()
                    airportsListData.parseAirportList(airportListData: Item as! Dictionary<String, Any>)
                    results.append(airportsListData)
                }
            }
            
        } else {
            self.isSuccess = false
           
        }
    }
    
    static func build(_ dict: [String: AnyObject]) -> AirportListModel {
        var list = AirportListModel()
        list.parseAirportListResponse(response: dict)
        return list
    }
}


struct AirportsList {

    var latitude                    : Double = 0.0
    var longitude                   : Double = 0.0
    var northEastlatitude           : String = ""
    var northEastlongitude          : String = ""
    var southWestlatitude           : String = ""
    var southWestlongitude          : String = ""
    var icon                        : String = ""
    var id                          : String = ""
    var name                        : String = ""
    var open_now                    : String = ""
    var place_id                    : String = ""
    var compound_code               : String = ""
    var global_code                 : String = ""
    var rating                      : Float = 0.0
    var reference                   : String = ""
    var user_ratings_total          : Int = 0
    var scope                       : String = ""
    var vicinity                    : String = ""
    
    mutating func parseAirportList(airportListData: Dictionary<String, Any>) {
     print(#function)
     print(airportListData)
        
        if let airportListDataResponse:Dictionary<String, Any> = airportListData["geometry"] as? Dictionary<String, Any>{
            
            if let locationResponse:Dictionary<String, Any> = airportListDataResponse["location"] as? Dictionary<String, Any>{
                
                if let latitude = locationResponse["lat"] as? Double {
                    self.latitude = latitude
                }
                
                if let longitude = locationResponse["lng"] as? Double {
                    self.longitude = longitude
                }
            }
            
            if let viewportResponse:Dictionary<String, Any> = airportListDataResponse["viewport"] as? Dictionary<String, Any>{
                
                if let northeastResponse:Dictionary<String, Any> = viewportResponse["northeast"] as? Dictionary<String, Any>{
                    
                    if let northEastlatitude = northeastResponse["lat"] as? String {
                        self.northEastlatitude = northEastlatitude
                    }
                    
                    if let northEastlongitude = northeastResponse["lng"] as? String {
                        self.northEastlongitude = northEastlongitude
                    }
                }
                
                if let southwestResponse:Dictionary<String, Any> = viewportResponse["southwest"] as? Dictionary<String, Any>{
                    
                   if let southWestlatitude = southwestResponse["lat"] as? String {
                        self.southWestlatitude = southWestlatitude
                    }
                    
                    if let southWestlongitude = southwestResponse["lng"] as? String {
                        self.southWestlongitude = southWestlongitude
                    }
                }
            }
        }
        
        if let icon = airportListData["icon"] as? String {
            self.icon = icon
        }
        
        if let id = airportListData["id"] as? String {
            self.id = id
        }
        
        if let name = airportListData["name"] as? String {
            self.name = name
        }
        
        if let opening_hoursResponse:Dictionary<String, Any> = airportListData["opening_hours"] as? Dictionary<String, Any>{
            
           if let open_now = opening_hoursResponse["open_now"] as? String {
                self.open_now = open_now
            }
        }
        
        if let place_id = airportListData["place_id"] as? String {
            self.place_id = place_id
        }
        
        if let plus_codeResponse:Dictionary<String, Any> = airportListData["plus_code"] as? Dictionary<String, Any>{
            
           if let compound_code = plus_codeResponse["compound_code"] as? String {
                self.compound_code = compound_code
            }
            if let global_code = plus_codeResponse["global_code"] as? String {
                self.global_code = global_code
            }
        }
        
        if let rating = airportListData["rating"] as? Float {
            self.rating = rating
        }
        
        if let reference = airportListData["reference"] as? String {
            self.reference = reference
        }
        
        if let scope = airportListData["scope"] as? String {
            self.scope = scope
        }
        
        if let user_ratings_total = airportListData["user_ratings_total"] as? Int {
            self.user_ratings_total = user_ratings_total
        }
        
        if let vicinity = airportListData["vicinity"] as? String {
            self.vicinity = vicinity
        }
    }
}
