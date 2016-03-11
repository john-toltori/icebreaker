//
//  BeginViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/6/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class BeginViewController: UIViewController {

    var ble: BLE! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier where id == "gotoMeasure" {
            let vc = segue.destinationViewController as! MeasureViewController
            vc.memberIndex = 0
            vc.ble = self.ble
        }
    }

    @IBAction func onCloseBtn_Click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onNextBtn_Click(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoMeasure", sender: self)
    }
}
