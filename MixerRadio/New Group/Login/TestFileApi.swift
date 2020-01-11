//
//  TestFileApi.swift
//  MixerRadio
//
//  Created by Antony Dhikshit on 29/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import Foundation

struct TestFileApi:Codable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
