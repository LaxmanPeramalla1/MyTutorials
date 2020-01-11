//
//  Settings.swift
//  MixerRadio
//
//  Created by Laxman on 13/06/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

class Settings: NSObject {

    class func setExistuserStatus(status: Bool){
        let userDefaults = UserDefaults.standard
        userDefaults.set(status, forKey: EXISTUSERSTATUS)
    }
    class func getExistuserStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: EXISTUSERSTATUS)
    }
}
