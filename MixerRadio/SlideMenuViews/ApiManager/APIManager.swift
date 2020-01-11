//
//  APIManager.swift
//  SQLLIGHTWITHMVC
//
//  Created by Raghvendra on 22/05/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
typealias CompletionHandler = ( _ success:Bool , _ response: NSDictionary) -> Void
//protocol APIManagerDelegate: class {
//    //func receiveResponseWithSucess ( tag: Int ,responce: NSDictionary)
//    //func receiveError ( tag: Int ,error: NSError)
//    func test(str : String)
//}
class APIManager {
//     weak var delegate:APIManagerDelegate?
    var tempresponse : JSON = JSON.null
    static let sharedInstance = APIManager()
    private init() {
        
    }

    func Apicall(url:String,para:Dictionary<String, Any>  ,onCompletion:@escaping (_ userJson:JSON)-> Void)-> JSON   {
        self.tempresponse = ""
        var accessTokan = String()
//        if  isKeyPresentInUserDefaults(key: ACCESSTOKEN)
//        {
//            accessTokan = UserDefaults.standard.value(forKey: ACCESSTOKEN) as! String
//            if accessTokan.characters.count == 0 {
//                accessTokan = ""
//            }
//
//        }
        let headers: HTTPHeaders = [
            "access-token": accessTokan,
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            
            if response.response?.statusCode == 400
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Please login to access this service" )
                return
            }
            if response.response?.statusCode == 401
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Unauthorized access, You are trying to access others data." )
                return
            }
            if response.response?.statusCode == 440
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Invalid acces token / session expired." )
                return
            }
            switch response.result
            {
            case.success(let data):
                print("",data)
                let response = JSON(data)
                onCompletion(response)
                self.tempresponse = JSON(data)
                
            case.failure(let error):
                onCompletion(JSON.null)
                print("",error)
            }
        }
       
     return tempresponse
    }
    func getApicall(url:String ,onCompletion:@escaping (_ userJson:JSON)-> Void)-> JSON   {
        self.tempresponse = ""
      
        Alamofire.request(url).responseJSON{ response in
            switch response.result
            {
            case.success(let data):
                
                let response = JSON(data)
                onCompletion(response)
                self.tempresponse = JSON(data)
                
            case.failure(let error):
                onCompletion(JSON.null)
                print("",error)
            }
        }
        return tempresponse
    }
    
    
    func postApicall(url:String, para:Dictionary<String, Any> ,onCompletion:@escaping (_ userJson:JSON)-> Void)-> JSON   {
         var x = para
//        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
//           x["version"] = text
//        }
        self.tempresponse = ""
        let headers: HTTPHeaders = [
            "access-token": "",
            "Accept": "application/json"
        ]
        print("url",url)
        print("para",x)
        Alamofire.request(url, method: .post , parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
            print("response",response)
            if response.response?.statusCode == 400
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Please login to access this service" )
                return
            }
            if response.response?.statusCode == 401
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Unauthorized access, You are trying to access others data." )
                return
            }
            if response.response?.statusCode == 440
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Invalid acces token / session expired." )
                return
            }
            switch response.result
            {
            case.success(let data):
                
                let response = JSON(data)
                onCompletion(response)
                self.tempresponse = JSON(data)
                
            case.failure(let error):
                onCompletion(JSON.null)
                print("",error)
            }
        }
        return tempresponse
    }
    
    func postApicallWithTokan(url:String, para:Dictionary<String, Any> ,onCompletion:@escaping (_ userJson:JSON)-> Void)   {
        self.postApicallWithTokan(url: url, para: para, isAddVersion: true, onCompletion: onCompletion)
    }
    func postApicallWithTokan(url:String, para:Dictionary<String, Any>, isAddVersion:Bool ,onCompletion:@escaping (_ userJson:JSON)-> Void)   {
        self.tempresponse = ""
        var x = para
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String{
            if (isAddVersion) {
                x["version"] = text
            }
        }
        var accessTokan = String()
//        if  isKeyPresentInUserDefaults(key: ACCESSTOKEN)
//        {
//            accessTokan = UserDefaults.standard.value(forKey: ACCESSTOKEN) as! String
//            if accessTokan.count == 0 {
//             accessTokan = ""
//            }
//
//        }
        let headers: HTTPHeaders = [
            "access-token": accessTokan,
            "Content-Type": "application/json"
        ]
        debugPrint("url",url)
        debugPrint("access-token",accessTokan)
//        debugPrint("param",x)
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: x,
            options: [.prettyPrinted]) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            debugPrint("Request",theJSONText!)
        }
        Alamofire.request(url, method: .post , parameters: x, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            if response.response?.statusCode == 400
            {
              onCompletion(JSON.null)
              self.postNotification(code: (response.response?.statusCode)!, message:"Please login to access this service" )
              return
            }
            if response.response?.statusCode == 401
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Unauthorized access, You are trying to access others data." )
                return
            }
            if response.response?.statusCode == 440
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Invalid acces token / session expired." )
                return
            }
            switch response.result
            {
            case.success(let data):
                let response = JSON(data)
                debugPrint("Response",response)
                onCompletion(response)
                self.tempresponse = JSON(data)
                
            case.failure(let error):
                onCompletion(JSON.null)
                print("",error)
            }
        }

    }
    
    func postApicallAfterLogin(url:String, para:Dictionary<String, Any> ,onCompletion:@escaping (_ userJson:JSON)-> Void)-> JSON   {
        self.tempresponse = ""
        var x = para
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            x["version"] = text
        }
        var accessTokan = String()
//        if  isKeyPresentInUserDefaults(key: ACCESSTOKEN)
//        {
//            accessTokan = UserDefaults.standard.value(forKey: ACCESSTOKEN) as! String
//            if accessTokan.characters.count == 0 {
//                accessTokan = ""
//            }
//
//        }
        
        let headers: HTTPHeaders = [
            "access-token": accessTokan,
            "content-type": "application/json"
        ]
        Alamofire.request(url, method: .post , parameters: x, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            
            if response.response?.statusCode == 400
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Please login to access this service" )
                return
            }
            if response.response?.statusCode == 401
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Unauthorized access, You are trying to access others data." )
                return
            }
            if response.response?.statusCode == 440
            {
                onCompletion(JSON.null)
                self.postNotification(code: (response.response?.statusCode)!, message:"Invalid acces token / session expired." )
                return
            }
            switch response.result
            {
            case.success(let data):
                print("",data)
                let response = JSON(data)
                onCompletion(response)
                self.tempresponse = JSON(data)
                
            case.failure(let error):
                onCompletion(JSON.null)
                print("",error)
            }
        }
        return tempresponse
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func postNotification(code : Int , message: String )  {
        let data = ["code":code,
                    "message":message,
        ] as [String : Any] 
        let nc = NotificationCenter.default
//        nc.post(name:Notification.Name(rawValue:STATUSCODENOTI),
//                object: nil,
//                userInfo: data)
    }
    
    
}



