
//  APIRouter.swift
//  MixerRadio
//
//  Created by Antony Dhikshit on 29/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case bannerImages, radioStreamingUrl
    case login(username:String, password:String)
    case forgotPwdUserName(userName:String)
//    case testFileApi
//    case posts
//    case post(id: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .bannerImages, .radioStreamingUrl, .forgotPwdUserName:
            return .get
        case .login:
            return .post
       
//        case .testFileApi:
//            return .get
//        case .posts, .post:
//            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .bannerImages:
            return "/GetBannerImages"
        case .radioStreamingUrl:
            return "/GetRadioStreamingURL/?stationName=Jamz"
        case .login:
            return "/Login"
        case .forgotPwdUserName:
            return "/ValidateUser"
//        case .testFileApi:
//            return "/posts/1"
//        case .posts:
//            return "/posts"
//        case .post(let id):
//            return "/posts/\(id)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password]
        case .bannerImages, .radioStreamingUrl:
            return nil
        case .forgotPwdUserName(let userName):
            return [K.APIParameterKey.userName: userName]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
//        let url = try K.ProductionServer.baseURL.asURL()
//
//        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        let wholeURL = K.ProductionServer.baseURL.appending(path)
        let urlwithPercent = wholeURL.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var urlRequest = Foundation.URLRequest(url: URL(string: urlwithPercent!)!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
