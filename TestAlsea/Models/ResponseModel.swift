//
//  ResponseModel.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseModel: Mappable, CustomStringConvertible {
    
    var starttime: String = ""
    var endtime: String = ""
    var minmagnitude: String = ""
    
    init() {
        
    }
    
    init(start: String, end: String, min: String) {
        self.starttime = start
        self.endtime = end
        self.minmagnitude = min
    }
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        starttime <- map["starttime"]
        endtime <- map["endtime"]
        minmagnitude <- map["minmagnitude"]
    }
    
    var description: String {
        return "ListFeedModel:{\(starttime), \(endtime), \(minmagnitude)}"
    }
    
    func getRequestString() -> String {
        return "starttime=\(self.starttime)&endtime=\(self.endtime)&minmagnitude=\(self.minmagnitude)"
    }
}
