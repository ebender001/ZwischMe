//
//  ResidentHomeViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class ResidentHomeViewController: UIViewController {
    @IBOutlet weak var newCaseButton: UIButton!
    @IBOutlet weak var pendingCasesButton: UIButton!
    @IBOutlet weak var completedCasesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Resident Home"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: nil, action: nil)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logout:")
        
        
        newCaseButton.backgroundColor = greenColor
        pendingCasesButton.backgroundColor = mediumBlueColor
        completedCasesButton.backgroundColor = purpleColor
        for item: UIView in view.subviews {
            if item.isKindOfClass(UIButton) {
                let btn = item as? UIButton
                btn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                btn?.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30.0)
                btn?.layer.shadowColor = UIColor.blackColor().CGColor
                btn?.layer.shadowOffset = CGSize(width: 2, height: 2)
                btn?.layer.shadowOpacity = 0.5
                btn?.layer.shadowRadius = 3.0
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.tintColor = greyColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newCaseButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier(newCaseSegue, sender: nil)
    }
    @IBAction func pendingCaseButtonTapped(sender: AnyObject) {
    }
    @IBAction func completedCaseButtonTapped(sender: AnyObject) {
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
