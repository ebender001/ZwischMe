//
//  CaseDateViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class CaseDateViewController: UIViewController  {

    @IBOutlet weak var caseDatePicker: UIDatePicker!
    @IBOutlet weak var caseOrderSeg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Date of Case"
        caseDatePicker.maximumDate = NSDate()
        if let caseDate = Case.sharedInstance.caseDate {
            caseDatePicker.setDate(caseDate, animated: true)
        }
        
        caseOrderSeg.selectedSegmentIndex = Case.sharedInstance.caseOfDay - 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let caseDate = Case.sharedInstance.caseDate {
            caseDatePicker.setDate(caseDate, animated: true)
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Case.sharedInstance.caseDate = caseDatePicker.date
        Case.sharedInstance.caseOfDay = caseOrderSeg.selectedSegmentIndex + 1
        let df = NSDateFormatter()
        df.dateStyle = .MediumStyle
        df.timeStyle = .NoStyle
        let dateString = df.stringFromDate(caseDatePicker.date)
        let caseNumberString = "case number \(caseOrderSeg.selectedSegmentIndex + 1)"
        
        Case.sharedInstance.caseDateSummary = "\(dateString) - \(caseNumberString)"
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
