//
//  ResidentHomeViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit


class ResidentHomeViewController: UIViewController, PendingCasesFetcherProtocol {
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
        Case.sharedInstance.clearCase()
        performSegueWithIdentifier(newCaseSegue, sender: nil)
    }
    
    @IBAction func pendingCaseButtonTapped(sender: AnyObject) {
        EZLoadingActivity.show("Fetching...", disableUI: true)
        let pendingCasesFetcher = PendingCasesFetcher()
        pendingCasesFetcher.delegate = self
        pendingCasesFetcher.startFetch()
    }
    
    @IBAction func completedCaseButtonTapped(sender: AnyObject) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == pendingCasesSegue {
            let vc = segue.destinationViewController as? PendingCasesTableViewController
            vc?.casesArray = sender as? [Case]
        }
    }
    
    //MARK: - DELEGATE METHODS
    func didFetchCases(cases: [Case]) {
        EZLoadingActivity.hide()
        self.performSegueWithIdentifier(pendingCasesSegue, sender: cases)
    }
    func failedToFetchCases(reason: String) {
        EZLoadingActivity.hide()
        SJNotificationViewController(parentView: self.navigationController!.view, title: reason, level: SJNotificationLevelMessage, position: SJNotificationPositionBottom, spinner: false).showFor(2)
    }

}
