//
//  MenuViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/14/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

protocol MenuItemSelectProtocol {
    func onMenuItemSelected(index: Int)
}

class MenuViewController: UITableViewController {

    var delegate: MenuItemSelectProtocol! = nil
    var items = ["Calibrate", "Disconnect", "Voice", "Heart", "Exit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "MenuCell")
        }
        
        cell!.textLabel!.text = items[indexPath.row]
        cell!.backgroundColor = UIColor.clearColor()
        
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate.onMenuItemSelected(indexPath.row)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
