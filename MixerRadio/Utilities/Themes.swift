//
//  Themes.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 18/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

struct ButtonTheme {
    // Buttons
    static let buttonWhitheBorder = UIColor(red:1, green:1, blue:1, alpha:1)
    static let buttonNormal   = UIColor(red:0.2431, green:0.5216, blue:0.6196, alpha:1.0)
    static let buttonSelected = UIColor(red:0.2431, green:0.5216, blue:0.6196, alpha:0.75)
    
//    static let backgroundPattern = UIColor(patternImage: UIImage(named: "pattern"))
    
    // Typeface
    static let defaultFont = UIFont(name: "ProximaNova-Regular", size:18.0)
    static let navBarFont  = UIFont(name: "ProximaNova-Regular", size:16.0)
}

struct RadioTheme {
    static let primaryBackgroundColor = UIColor(red:0.7607, green:0.1058, blue:0.0588, alpha:1)
    static let buttonDisabledColor = UIColor.lightGray
}
