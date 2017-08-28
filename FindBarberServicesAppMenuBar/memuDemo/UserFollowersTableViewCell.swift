//
//  UserFollowersTableViewCell.swift
//  memuDemo
//
//  Created by Christian Zamudio on 8/11/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class UserFollowersTableViewCell: UITableViewCell {

    @IBOutlet weak var followerUserImage: UIImageView!
    @IBOutlet weak var followerUserName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
