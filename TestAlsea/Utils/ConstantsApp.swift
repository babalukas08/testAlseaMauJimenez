//
//  ConstantsApp.swift
//  TestAlsea
//
//  Created by Mauricio Jimenez on 17/10/17.
//  Copyright © 2017 com.MauJimenez. All rights reserved.
//

import Foundation
public struct ConstantsApp {
    
    struct UrlRequest {
        static let baseURl = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&"
    }
}

enum FeedListCellType: String {
    case none
    case ListView
}
