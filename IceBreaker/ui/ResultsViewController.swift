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
        cell.ivProfileImage.image = indexPath.row < Members.getInstance().count - 1 ? member.profileImage : UIImage(named: "group")
        cell.lblName.text = indexPath.row < Members.getInstance().count - 1 ? member.name : "Group"
        cell.lblValue.text = "\(member.getValue())"
        cell.selectionStyle = .None
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    */

    @IBAction func onCloseBtn_Click(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
}
