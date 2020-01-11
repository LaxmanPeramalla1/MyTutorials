//
//  BannerImagesResponseModel.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 30/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

struct BannerImagesResponseModel: Codable {
    let statusCode: Int
    let statusDescription, errors: String?
    let data: [String]
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case statusDescription = "StatusDescription"
        case errors = "Errors"
        case data = "Data"
    }
}
