//
//  DifficultyViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {

    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var averageButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true

        title = "Select Difficulty"
        easyButton.backgroundColor = greenColor
        averageButton.backgroundColor = tanColor
        hardButton.backgroundColor = UIColor(red: 180/255.0, green: 0, blue: 0, alpha: 1.0)
        
        for item: UIView in view.subviews {
            if item.isKindOfClass(UIButton) {
                item.layer.shadowColor = UIColor.blackColor().CGColor
                item.layer.shadowOffset = CGSize(width: 2, height: 2)
                item.layer.shadowOpacity = 0.5
                item.layer.shadowRadius = 2
                let btn = item as! UIButton
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btn.titleLabel?.minimumScaleFactor = 0.5
                btn.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
                btn.titleLabel?.layer.shadowOffset = CGSize(width: 2, height: 2)
                btn.titleLabel?.layer.shadowOpacity = 0.5
                btn.titleLabel?.layer.shadowRadius = 2
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func easyTapped(sender: AnyObject) {
        Case.sharedInstance.residentDifficulty = "Easiest one-third"
        delay(0.2) { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    @IBAction func averageTapped(sender: AnyObject) {
        Case.sharedInstance.residentDifficulty = "Average"
        delay(0.2) { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func hardTapped(sender: AnyObject) {
        Case.sharedInstance.residentDifficulty = "Hardest one-third"
        delay(0.2) { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
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
