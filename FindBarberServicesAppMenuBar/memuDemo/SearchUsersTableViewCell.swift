//
//  SearchUsersTableViewCell.swift
//  memuDemo
//
//  Created by Christian Zamudio on 8/8/17.
//  Copyright © 2017 Parth Changela. All rights reserved.
//

import UIKit

class SearchUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameUILabel: UILabel!
    @IBOutlet weak var userServiceProviderUILabel: UILabel!
    @IBOutlet weak var usersRatingIndicatorUIImageView: UIImageView!
    @IBOutlet weak var userUIImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
