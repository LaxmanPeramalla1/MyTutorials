//
//  Constants.swift
//  MixerRadio
//
//  Created by Antony Dhikshit on 29/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://192.168.21.49/mixerradio/api/Account"
//        static let baseURL = "https://jsonplaceholder.typicode.com"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let username = "username"
        static let userName = "userName"
    }
    
//    struct APIResponseKey {
//        static let statusCode = "StatusCode"
//        static let statusDescription = "StatusDescription"
//        static let errors = "Errors"
//        static let data = "Data"
//    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
