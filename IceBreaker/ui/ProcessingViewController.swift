//
//  ProcessingViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class ProcessingViewController: UIViewController {
    
    var processingTimer: NSTimer! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        processingTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("onProcessingTimer:"), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if processingTimer != nil {
            processingTimer.invalidate()
        }
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func onProcessingTimer(timer: NSTimer) {
        self.performSegueWithIdentifier("gotoGroupLeader", sender: nil)
    }
}
