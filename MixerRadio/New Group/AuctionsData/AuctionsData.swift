//
//  AuctionsData.swift
//  MixerRadio
//
//  Created by Laxman on 19/06/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

class AuctionsData: NSObject {
}
class CurrentAuctionData: NSObject {
    var currentAucImgURL: String?
    var currentLeadBidPoints: String?
    var currentLeadBidderPoints: String?
    var currentplaceBid: String?
    var currentHrs: String?
      var currentAuctionID: Int16?
}
class PastAuctionData: NSObject {
    var pastAucImgURL: String?
    var pastWinnerBidPoints: Int16?
    var pastWinnerName: String?
    var pastAuctionTitle: String?
     var pastUserID: Int16?
    var stationAuctionBidID: Int16?
}
class WinnigAuctionData: NSObject {
    var winningAucImgURL: String?
    var winningBidPoints: String?
}
