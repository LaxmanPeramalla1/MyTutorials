//
//  FindFriendsCell.swift
//  MixerRadio
//
//  Created by Laxman on 26/05/18.
//  Copyright © 2018 Archana Kaveti. All rights reserved.
//

import UIKit
protocol FindFriendsCellDelegate : class {
    func addFriendRequest(_ sender: FindFriendsCell)
}
class FindFriendsCell: UITableViewCell {
    @IBOutlet var frind_profile_pic: UIImageView!
    
    @IBOutlet var find_fiend_delete_btn: UIButton!
    @IBOutlet var find_friend_name: UILabel!
    @IBOutlet var find_friend_details: UILabel!
    
    weak var delegate: FindFriendsCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addFriend(_ sender: UIButton) {
        delegate?.addFriendRequest(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
