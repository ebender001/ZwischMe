//
//  ResidentHomeViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit


class ResidentHomeViewController: UIViewController, PendingCasesFetcherProtocol, CompletedCasesFetcherProtocol, UserLogoutProtocol {
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
        registerForNotifications(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logout(sender: AnyObject?) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out? There really is no reason to do so if you are using the same account to submit cases.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            let userLogout = UserLogout()
            userLogout.delegate = self
            userLogout.logout()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .Destructive, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
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
        EZLoadingActivity.show("Fetching...", disableUI: true)
        let completedCasesFetcher = CompletedCasesFetcher()
        completedCasesFetcher.delegate = self
        completedCasesFetcher.startFetch()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == pendingCasesSegue {
            let vc = segue.destinationViewController as? PendingCasesTableViewController
            vc?.casesArray = sender as? [Case]
        }
        if segue.identifier == completedCasesSegue {
            let array = sender as? [[Case]]
            let unviewed = array![0]
            let viewed = array![1]
            let vc = segue.destinationViewController as? CompletedCasesTableViewController
            vc?.unViewedCases = unviewed
            vc?.viewedCases = viewed
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
    
    func didFetchCompletedCases(unviewedCases: [Case], viewedCases: [Case]) {
        EZLoadingActivity.hide()
        let array = [unviewedCases, viewedCases]
        self.performSegueWithIdentifier(completedCasesSegue, sender: array)
    }
    func failedToFetchCompletedCases(reason: String) {
        EZLoadingActivity.hide()
        SJNotificationViewController(parentView: self.navigationController!.view, title: reason, level: SJNotificationLevelMessage, position: SJNotificationPositionBottom, spinner: false).showFor(2)
    }
    
    func didLogout(controller: UserLogout) {
        controller.delegate = nil
        navigationController?.popViewControllerAnimated(true)
    }
    func failedToLogout(reason: String, controller: UserLogout) {
        controller.delegate = nil
        let alert = UIAlertController(title: "Logout Failed", message: reason, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

}
