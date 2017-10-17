//
//  EarthquakeResponseModel.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import Foundation
import ObjectMapper

class EarthquakeResponseModel: Mappable, CustomStringConvertible {
    
    var type: String = ""
    var metadata: MetadataModel?
    var features: [FeaturesModel] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        metadata <- map["metadata"]
        features <- map["features"]
    }
    
    var description: String {
        return "ListFeedModel:{\(type), \(metadata), \(features)}"
    }
    
}

class MetadataModel: Mappable, CustomStringConvertible {
    
    var type: String = ""
    var url: String = ""
    var title: String = ""
    var status: String = ""
    var api: String = ""
    var count: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        url <- map["url"]
        title <- map["title"]
        status <- map["status"]
        api <- map["api"]
        count <- map["count"]
    }
    
    var description: String {
        return "MetadataModel:{\(type), \(url), \(status)}"
    }

}

class FeaturesModel: Mappable, CustomStringConvertible {
    
    var generated: Double = 0
    var properties: PropertiesModel?
    var geometry: GeometryModel?
    var id: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        generated <- map["generated"]
        properties <- map["properties"]
        geometry <- map["geometry"]
        id <- map["id"]
    }
    
    var description: String {
        return "FeaturesModel:{\(generated), \(properties), \(geometry)}"
    }
    
}

class PropertiesModel: Mappable, CustomStringConvertible {
    
    var mag: Double = 0
    var time: Int = 0
    var updated: Int = 0
    var title: String = ""
    var place: String = ""
    var detail: String = ""
    var alert: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        mag <- map["mag"]
        place <- map["place"]
        title <- map["title"]
        detail <- map["detail"]
        alert <- map["alert"]
        time <- map["time"]
        updated <- map["updated"]
    }
    
    var description: String {
        return "PropertiesModel:{\(mag), \(place)}"
    }
    
}

class GeometryModel: Mappable, CustomStringConvertible {
    
    var type: String = ""
    var coordinates: [Double] = []

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        coordinates <- map["coordinates"]
    }
    
    var description: String {
        return "PropertiesModel:{\(type), \(coordinates)}"
    }
    
}
