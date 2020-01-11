//
//  RadioStreamingView.swift
//  MixerRadioiOSApp
//
//  Created by Pavan Kothur on 09/04/18.
//  Copyright © 2018 Pavan Kothur. All rights reserved.
//

import UIKit

class RadioStreamingView: CustomViewBackground {
    
    @IBOutlet weak var labelAlbumName: UILabel!
    @IBOutlet weak var labelArtistName: UILabel!
    @IBOutlet weak var buttonPlayOrPause:UIButton!
    @IBOutlet weak var arrowImage:UIImageView!
    @IBOutlet weak var labelArtistNameWhenRadioHidden:UILabel!
    @IBOutlet weak var viewOverlay:UIView!
    @IBOutlet weak var viewPlaying:UIStackView!
    
    var radioViewState: RadioViewState! = RadioViewState.isOpen
    var radioStreamingState: RadioStreamingState! = RadioStreamingState.isPlaying
    var radioViewHeightWhenMinimized:CGFloat = 20
    
    
    
    @IBOutlet weak var labelAlbumName1: UILabel!
    @IBOutlet weak var labelArtistName1: UILabel!
    @IBOutlet weak var buttonPlayOrPause1:UIButton!
    @IBOutlet weak var arrowImage1:UIImageView!
    @IBOutlet weak var labelArtistNameWhenRadioHidden1:UILabel!
    @IBOutlet weak var viewOverlay1:UIView!
    @IBOutlet weak var viewPlaying1:UIStackView!
    
    var radioViewState1: RadioViewState! = RadioViewState.isOpen
    var radioStreamingState1: RadioStreamingState! = RadioStreamingState.isPlaying
    var radioViewHeightWhenMinimized1:CGFloat = 20
}

extension RadioStreamingView {
    enum RadioViewState {
        case isOpen
        case isHidden
    }
    
    enum RadioStreamingState {
        case isPlaying
        case isOnPause
    }
}
