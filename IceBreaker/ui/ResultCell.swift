//
//  ResultCell.swift
//  IceBreaker
//
//  Created by toltori on 3/10/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
