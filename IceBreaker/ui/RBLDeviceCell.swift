//
//  RBLDeviceCell.swift
//  IceBreaker
//
//  Created by toltori on 3/9/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class RBLDeviceCell: UITableViewCell {

    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblRssi: UILabel!
    @IBOutlet weak var lblUuid: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
