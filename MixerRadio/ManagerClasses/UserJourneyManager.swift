//
//  UserJourneyManager.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 23/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
import Foundation

class UserJourneyManager {
    static func updateRootVC(){

        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        print("Userjourney Status:- \(status)")
        
        if(status == false){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "preLoginViewController") as! PreLoginViewController
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationController:UINavigationController = appDelegate.window?.rootViewController as! UINavigationController
        navigationController.viewControllers = [rootVC!]
        setNavigationBarStyle(navigationController)
    }
    
    static func setNavigationBarStyle(_ navigationController:UINavigationController){
        navigationController.navigationBar.barTintColor = RadioTheme.primaryBackgroundColor
        navigationController.navigationBar.tintColor = UIColor.white
    }
}

