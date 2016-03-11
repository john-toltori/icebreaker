//
//  GroupLeaderViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class GroupLeaderViewController: UIViewController {

    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage1: UILabel!
    @IBOutlet weak var lblMessage2: UILabel!
    
    var groupLeaderIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseBtn_Click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier! == "gotoShare" {
            let vc = segue.destinationViewController as! ShareViewController
            vc.groupLeaderIndex = self.groupLeaderIndex
        }
    }

    func initUI() {
        if let index = groupLeaderIndex {
            let leader = Members.getInstance().members[index]
            ivProfileImage.image = leader.profileImage
            lblName.text = leader.name
            lblMessage1.text = "\(leader.name) has been selected as your GRUOP LEADER based on analysis of the teams individual GSR measurements."
            lblMessage2.text = "Please keep in mind that \(leader.name) could have had the hands with the most SWEAT :)"
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
