//
//  MemberCell.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnMeasure: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
