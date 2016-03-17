//
//  ResultsViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblResults: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Members.getInstance().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultCell
        
        let member: MemberInfo = Members.getInstance().members[indexPath.row]
        cell.ivProfileImage.image = member.profileImage
        cell.lblName.text = member.name
        cell.lblValue.text = "\(member.getValue())"
        cell.selectionStyle = .None
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier! == "gotoGroupLeader" {
            let vc = segue.destinationViewController as! GroupLeaderViewController
            vc.groupLeaderIndex = Members.getInstance().findGroupLeaderIndex()
        }
    }

    @IBAction func onNextBtn_Click(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoGroupLeader", sender: self)
    }
}
