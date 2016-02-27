//
//  CaseDateViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class CaseDateViewController: UIViewController {

    @IBOutlet weak var caseDatePicker: UIDatePicker!
    @IBOutlet weak var caseOrderSeg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Date of Case"
        caseDatePicker.maximumDate = NSDate()
        
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

}
