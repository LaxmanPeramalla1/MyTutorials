//
//  FriendRequestCell.swift
//  MixerRadio
//
//  Created by Laxman on 26/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
protocol FriendRequestCellDelegate : class {
    func acceptFriendRequest(_ sender: FriendRequestCell)
     func denyFriendRequest(_ sender: FriendRequestCell)
}
class FriendRequestCell: UITableViewCell {
    @IBOutlet var frd_req_profile_pic: UIImageView!
    @IBOutlet var frd_req_username: UILabel!
    @IBOutlet var frd_req_userdetails: UILabel!
    @IBOutlet var frd_req_accept_btn: UIButton!
    
    @IBOutlet var frd_req_deny_btn: UIButton!
     weak var delegate: FriendRequestCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func acceptFriend(_ sender: UIButton) {
        delegate?.acceptFriendRequest(self)
    }
    @IBAction func denyFriend(_ sender: UIButton) {
        delegate?.denyFriendRequest(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
