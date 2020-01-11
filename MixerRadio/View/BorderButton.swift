//
//  BorderButton.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 18/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

//class BorderButton: UIButton {
//
//}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = ButtonTheme.buttonWhitheBorder.cgColor
        }
        get {
            return ButtonTheme.buttonSelected
        }
    }
}
