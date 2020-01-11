//
//  LoginModelResponse.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 25/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import Foundation

struct LoginResponseModel: Codable {
    
//    {
//    "StatusCode": 0,
//    "StatusDescription": "Provide Parameters with values",
//    "Errors": null,
//    "Data": null
//    }
//
    let statusCode: Int
    let statusDescription: String?
    let errors: String?
    let data: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case statusDescription = "StatusDescription"
        case errors = "Errors"
        case data = "Data"
    }
}
