//
//  CalculationsViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/7/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class CalculationsViewController: UIViewController {

    @IBOutlet weak var lblMean: UILabel!
    @IBOutlet weak var lblMedian: UILabel!
    @IBOutlet weak var lblRange: UILabel!
    @IBOutlet weak var lblGroupGsr: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblMean.text = "Mean = \(Members.getInstance().findMean())"
        lblMedian.text = "Median = \(Members.getInstance().findMedian())"
        lblRange.text = "Range = \(Members.getInstance().findRange())"
        lblGroupGsr.text = "\(Members.getInstance().members[Members.getInstance().count - 1].value)"
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
        self.navigationController!.popViewControllerAnimated(true)
    }
}
