//
//  RBLDevicesViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/9/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class RBLDevicesViewController: UITableViewController {

    var ble: BLE! = nil
    var devices: [BLEDevice]! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.hidesBackButton = true
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
        return devices == nil ? 0 : devices.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RBLDeviceCell", forIndexPath: indexPath) as! RBLDeviceCell
        
        cell.lblDeviceName.text = devices[indexPath.row].name
        if ble.peripheralsRssi != nil {
            cell.lblRssi.text = "\(ble.peripheralsRssi[indexPath.row])"
        } else {
            cell.lblRssi.text = "Unknown"
        }
        cell.lblUuid.text = devices[indexPath.row].uuid

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if ble.peripherals != nil && ble.peripherals.count > indexPath.row {
            ble.connectPeripheral(ble.peripherals[indexPath.row] as! CBPeripheral)
        }
        self.navigationController!.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onCloseBtn_Click(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
}
