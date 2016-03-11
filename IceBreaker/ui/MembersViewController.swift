//
//  MembersViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/6/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit
import MobileCoreServices

class MembersViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, BLEDelegate {

    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var pvMemberCount: UIPickerView!
    @IBOutlet weak var tblMembers: UITableView!
    var indexForImage: Int = 0
    var indexForMeasure: Int = 0
    var ble: BLE! = nil
    var devices: [BLEDevice]! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pvMemberCount.selectRow(Members.getInstance().count - 1, inComponent: 0, animated: true)
        initBLE()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Members.getInstance().count = row + 1
        tblMembers.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Members.getInstance().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MemberCell = tableView.dequeueReusableCellWithIdentifier("MemberCell", forIndexPath: indexPath) as! MemberCell
        
        cell.ivProfileImage.image = Members.getInstance().members[indexPath.row].profileImage != nil ? Members.getInstance().members[indexPath.row].profileImage : UIImage(named: "empty")
        cell.txtName.text = Members.getInstance().members[indexPath.row].name
        cell.txtName.delegate = self
        cell.btnCamera.removeTarget(self, action: Selector("onCameraBtn_Click:"), forControlEvents: .TouchUpInside)
        cell.btnGallery.removeTarget(self, action: Selector("onGalleryBtn_Click:"), forControlEvents: .TouchUpInside)
        cell.btnMeasure.removeTarget(self, action: Selector("onMeasureBtn_Click:"), forControlEvents: .TouchUpInside)
        
        cell.btnCamera.addTarget(self, action: Selector("onCameraBtn_Click:"), forControlEvents: .TouchUpInside)
        cell.btnGallery.addTarget(self, action: Selector("onGalleryBtn_Click:"), forControlEvents: .TouchUpInside)
        cell.btnMeasure.addTarget(self, action: Selector("onMeasureBtn_Click:"), forControlEvents: .TouchUpInside)
        
        cell.txtName.tag = indexPath.row
        cell.btnCamera.tag = indexPath.row
        cell.btnGallery.tag = indexPath.row
        cell.btnMeasure.tag = indexPath.row
        cell.selectionStyle = .None
        
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let index = textField.tag
        Members.getInstance().members[index].name = textField.text == nil ? "" : textField.text!
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: -- UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if image == nil {
            return
        }

        Members.getInstance().members[indexForImage].profileImage = image
        tblMembers.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier == "gotoRBLDeviceList" {
            let vc = segue.destinationViewController as! RBLDevicesViewController
            vc.ble = self.ble
            vc.devices = self.devices
        } else if segue.identifier != nil && segue.identifier == "gotoMeasure" {
            let vc = segue.destinationViewController as! MeasureViewController
            vc.memberIndex = indexForMeasure
            vc.ble = self.ble
        } else if segue.identifier != nil && segue.identifier == "gotoBegin" {
            let vc = segue.destinationViewController as! BeginViewController
            vc.ble = self.ble
        }
    }

    @IBAction func onScanBtn_Click(sender: AnyObject) {
        if ble.activePeripheral != nil && ble.activePeripheral.state == .Connected {
            ble.CM.cancelPeripheralConnection(ble.activePeripheral)
        }
        
        if ble.peripherals != nil {
            ble.peripherals = nil
        }
        
        btnScan.enabled = false
        ble.findBLEPeripherals(3)
        self.view.makeToastActivity(message: "Scanning...")
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("onScanTimer:"), userInfo: nil, repeats: false)
    }
    
    func onScanTimer(timer: NSTimer) {
        btnScan.enabled = true
        self.view.hideToastActivity()
        devices.removeAll()
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
    }
    
    @IBAction func onNextBtn_Click(sender: AnyObject) {
        //
        // [2016/03/09 21:25 KSH]Check if the sensor device is connected
        //
        if ble.activePeripheral != nil && ble.activePeripheral.state == .Connected {
            //
            // Goto measure vc.
            //
            if verifyMembersProfile() {
                self.performSegueWithIdentifier("gotoBegin", sender: self)
            }
        } else {
            self.view.makeToast(message: "Please connect to the sensor device!")
        }
//        if verifyMembersProfile() {
//            self.performSegueWithIdentifier("gotoBegin", sender: self)
//        }
    }
    
    @IBAction func onResultsBtn_Click(sender: AnyObject) {
        if verifyMembersProfile() {
            self.performSegueWithIdentifier("gotoResults", sender: self)
        }
    }
    
    func onCameraBtn_Click(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            indexForImage = (sender as! UIButton).tag
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func onGalleryBtn_Click(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            indexForImage = (sender as! UIButton).tag
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func onMeasureBtn_Click(sender: AnyObject) {
        if verifyMembersProfile((sender as! UIButton).tag) {
            indexForMeasure = (sender as! UIButton).tag
            self.performSegueWithIdentifier("gotoMeasure", sender: self)
        }
    }
    
    func initBLE() {
        ble = BLE()
        ble.delegate = self
        ble.controlSetup()
        
        devices = [BLEDevice]()
    }
    
    func bleDidConnect() {
        self.view.makeToast(message: "Connected to the sensor device.\nNow you can start measuring!")
    }
    
    func bleDidDisconnect() {
        self.view.makeToast(message: "Disconnected from the sensor device!")
    }
    
    func bleDidReceiveData(data: UnsafeMutablePointer<UInt8>, length: Int32) {
        self.view.makeToast(message: "Received data from the sensor device!")
        if let processor = BLEDataProcessor.getInstance().processor {
            processor.processData(data, length: length)
        }
    }
    
    func bleDidUpdateRSSI(rssi: NSNumber!) {
    }
    
    func verifyMembersProfile(index: Int? = nil) -> Bool {
        if let memberIndex = index {
            if Members.getInstance().members[memberIndex].name.isEmpty {
                self.view.makeToast(message: "Please input \(memberIndex+1)th member's name!")
                return false
            }
            if Members.getInstance().members[memberIndex].profileImage == nil {
                self.view.makeToast(message: "Please set \(memberIndex+1)th member's image!")
                return false
            }
            return true
        } else {
            for var i = 0; i < Members.getInstance().count; i++ {
                if Members.getInstance().members[i].name.isEmpty {
                    self.view.makeToast(message: "Please input \(i+1)th member's name!")
                    return false
                }
                if Members.getInstance().members[i].profileImage == nil {
                    self.view.makeToast(message: "Please set \(i+1)th member's image!")
                    return false
                }
            }
            return true
        }
    }
}
