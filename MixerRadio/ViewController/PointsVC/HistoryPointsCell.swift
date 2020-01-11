//
//  HistoryPointsCell.swift
//  MixerRadio
//
//  Created by Laxman on 28/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit

class HistoryPointsCell: UITableViewCell {
    @IBOutlet var history_DateTimeLbl: UILabel!
    @IBOutlet var history_ActionLBL: UILabel!
    @IBOutlet var history_detailsLbl: UILabel!
    @IBOutlet var history_cashValLbl: UILabel!
    @IBOutlet var history_pointsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
