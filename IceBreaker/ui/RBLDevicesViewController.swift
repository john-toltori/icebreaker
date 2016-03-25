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
    var scanTimer: NSTimer! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        initData()
    }
    
    override func viewDidAppear(animated: Bool) {
        startScan()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if scanTimer != nil {
            scanTimer.invalidate()
            scanTimer = nil
            self.view.hideToastActivity()
        }
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
        self.dismissViewControllerAnimated(true, completion: nil)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        ble = appDelegate.ble
    }
    
    func startScan() {
        devices = [BLEDevice]()
        if ble.activePeripheral != nil && ble.activePeripheral.state == .Connected {
            ble.CM.cancelPeripheralConnection(ble.activePeripheral)
        }
        
        if ble.peripherals != nil {
            ble.peripherals = nil
        }
        
        ble.findBLEPeripherals(3)
        self.view.makeToastActivity(message: "Scanning...")
        scanTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("onScanTimer:"), userInfo: nil, repeats: false)
    }
    
    func onScanTimer(timer: NSTimer) {
        self.view.hideToastActivity()
        if ble.peripherals != nil && ble.peripherals.count > 0 {
            
            for var i = 0; i < ble.peripherals.count; i++ {
                let p = ble.peripherals[i] as! CBPeripheral
                let device = BLEDevice()
                
                device.uuid = p.identifier.UUIDString
                
                if let name = p.name {
                    device.name = name
                } else {
                    device.name = "RedBear Device(1)"
                }
                
                devices.append(device)
            }
            
            //
            // Goto the device list view.
            //
            self.performSegueWithIdentifier("gotoRBLDeviceList", sender: self)
        } else {
            //            //
            //            // test.
            //            //
            //            for var i = 0; i < 3; i++ {
            //                let dev = BLEDevice()
            //                dev.name = "device_\(i+1)"
            //                dev.uuid = "uuid_\(i+1)"
            //                devices.append(dev)
            //            }
            //            //
            //            // Goto the device list view.
            //            //
            //            self.performSegueWithIdentifier("gotoRBLDeviceList", sender: self)
            
            self.view.makeToast(message: "No BLE Device(s) found.")
        }
        self.tableView.reloadData()
    }
    
}
