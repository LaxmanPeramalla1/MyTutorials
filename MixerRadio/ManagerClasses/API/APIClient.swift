//
//  APIClient.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 25/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import Foundation 
import Alamofire

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        return Alamofire.request(route)
            .responseDecodableObject (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
//    static func testApi(completion:@escaping (Result<TestFileApi>)->Void) {
//        performRequest(route: APIRouter.testFileApi, completion: completion)
//    }
    
    static func login(username: String, password: String, completion:@escaping (Result<LoginResponseModel>)->Void) {
        performRequest(route: APIRouter.login(username: username, password: password), completion: completion)
    }
    
    static func getBannerImages(completion:@escaping (Result<BannerImagesResponseModel>)->Void) {
        performRequest(route: APIRouter.bannerImages, completion: completion)
    }
    
    static func getRadioStreamingUrl(completion:@escaping (Result<RadioStreamingUrlResponseModel>)->Void) {
        performRequest(route: APIRouter.radioStreamingUrl, completion: completion)
    }
    
    static func forgotPwd(userName: String, completion:@escaping (Result<LoginResponseModel>)->Void) {
        performRequest(route: APIRouter.forgotPwdUserName(userName: userName), completion: completion)
    }
}
