//
//  AccruedPointsCell.swift
//  MixerRadio
//
//  Created by Laxman on 28/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

class AccruedPointsCell: UITableViewCell {
    @IBOutlet var accrued_dateLbl: UILabel!
    @IBOutlet var accrued_scoreLbl: UILabel!
    @IBOutlet var accrued_songRateLbl: UILabel!
    @IBOutlet var accrued_pointsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
