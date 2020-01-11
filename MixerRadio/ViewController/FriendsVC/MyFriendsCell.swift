//
//  MyFriendsCell.swift
//  MixerRadio
//
//  Created by Laxman on 26/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
protocol MyFriendsCellDelegate : class {
    func myFriendDeleteRequest(_ sender: MyFriendsCell)
}
class MyFriendsCell: UITableViewCell {
    @IBOutlet var myfrd_profile_pic: UIImageView!
    @IBOutlet var myfrd_name: UILabel!
    @IBOutlet var myfrd_details: UILabel!
    @IBOutlet var myfrd_add_request_btn: UIButton!
      weak var delegate: MyFriendsCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func deleteFriend(_ sender: UIButton) {
        delegate?.myFriendDeleteRequest(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
