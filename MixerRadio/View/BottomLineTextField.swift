//
//  BottomLineTextField.swift
//  MixerRadio
//
//  Created by Pavan Kothur on 25/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

class BottomLineTextField: UITextField {

    @IBInspectable var hasError: Bool = false {
        didSet {
            
            if (hasError) {
                
                bottomBorder.backgroundColor = UIColor.red
                
            } else {
                
                bottomBorder.backgroundColor = UIColor(rgb: 0xE2DCD1)
                
            }
            
        }
    }
    
    var bottomBorder = UIView()
    
    override func awakeFromNib() {
        
        // Setup Bottom-Border
        self.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor(rgb: 0xE2DCD1) // Set Border-Color
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bottomBorder)
        
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
        
    }

}
