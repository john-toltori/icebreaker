//
//  SplashViewController.swift
//  IceBreaker
//
//  Created by toltori on 3/27/16.
//  Copyright © 2016 hyong. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.performSegueWithIdentifier("gotoIntro", sender: self)
    }
}
