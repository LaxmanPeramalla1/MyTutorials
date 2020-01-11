//
//  RadioStreamingUrlResponseModel.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 30/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import Foundation

struct RadioStreamingUrlResponseModel: Codable {
    let stationName, url: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case stationName = "StationName"
        case url = "URL"
        case message = "Message"
    }
}

