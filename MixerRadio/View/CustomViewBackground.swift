//
//  ViewBackground.swift
//  MixerRadio
//
//  Created by Antony Dhikshit on 19/04/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

class CustomViewBackground: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = RadioTheme.primaryBackgroundColor;
    }
}
