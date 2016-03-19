//
//  AttendingHomeTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit
import MessageUI

class AttendingHomeTableViewController: CustomTableViewController, AttendingHomeProtocol, AttendingCasesProtocol, MFMessageComposeViewControllerDelegate, UserLogoutProtocol {
    
    var cases: [Case]?
    var completedCase: Case?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.refreshControl?.tintColor = UIColor.whiteColor()

        title = "Pending Cases"
        tableView.backgroundColor = purpleColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cases", style: .Plain, target: nil, action: nil)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logOut:")
        EZLoadingActivity.show("Fetching...", disableUI: true)
        let fetcher = AttendingHomeCasesFetcher()
        fetcher.delegate = self
        fetcher.startFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if completedCase != nil {
            let alert = UIAlertController(title: "Notify Resident", message: "Do you want to notify the resident by text message that you have completed your evaluation?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                self.sendMessage(self.completedCase!)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .Destructive, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func refresh(sender: AnyObject?) {
        EZLoadingActivity.show("Fetching...", disableUI: true)
        let fetcher = AttendingHomeCasesFetcher()
        fetcher.delegate = self
        fetcher.startFetch()
    }
    
    func logOut(sender: AnyObject?) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out? There really is no reason to do so if you are using the same account to submit cases.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            let userLogout = UserLogout()
            userLogout.delegate = self
            userLogout.logout()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .Destructive, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cases = cases {
            return cases.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AttendingCasesCell, forIndexPath: indexPath)
        cell.accessoryType = .DisclosureIndicator
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        
        cell.detailTextLabel?.textColor = yellowColor
        cell.detailTextLabel?.font = UIFont(name: "Helvetica-Neue-Light", size: 14.0)
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.minimumScaleFactor = 0.5

        let theCase = cases![indexPath.row]
        cell.textLabel?.text = theCase.caseProcedureString()
        var name = ""
        if let fullName = theCase.residentObject?.fullName() {
            name = fullName
        }
        cell.detailTextLabel?.text = "\(theCase.caseDateString()): case #\(theCase.caseOfDay) with \(name)"
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let theCase = cases![indexPath.row]
        self.performSegueWithIdentifier(attendingCaseDetailSegue, sender: theCase)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70;
    }
    
    func showSmiley(){
        let smile = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        smile.contentMode = .ScaleAspectFit
        smile.image = UIImage(named: "smiley")
        smile.center = (self.navigationController?.view.center)!
        self.navigationController?.view.addSubview(smile)
        smile.alpha = 0
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            smile.alpha = 1.0
            }) { (done: Bool) -> Void in
                UIView.animateWithDuration(1.0, delay: 2.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    var center = smile.center
                    center.x += 1000
                    smile.center = center
                    }, completion: nil)
        }
    }
    
    //MARK: - NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == attendingCaseDetailSegue {
            let vc = segue.destinationViewController as? AttendingCaseDetailViewController
            vc?.delegate = self
            vc?.theCase = sender as? Case
        }
    }
    
    //MARK: - MESSAGING
    func sendMessage(finishedCase: Case) {
        if MFMessageComposeViewController.canSendText() {
            let mvc = MFMessageComposeViewController()
            mvc.messageComposeDelegate = self
            var cellNumber = ""
            var attending = ""
            if let number = finishedCase.residentObject?.cellNumber {
                cellNumber = number
            }
            if let name = finishedCase.attendingObject?.lastName {
                attending = "Dr. \(name)"
            }
            mvc.recipients = [cellNumber]
            mvc.body = "\(attending) has evaluated your case on the Zwisch Me app. Tap <a href='zwischmeApp://'></a>"
            self.presentViewController(mvc, animated: true, completion: nil)
            
        }
        else{
            let alert = showAlert(withTitle: "Message Error", withMessage: "This device can not send text messages.")
            presentViewController(alert, animated: true, completion: nil)
        }
        completedCase = nil
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if result == MessageComposeResultSent {
            SJNotificationViewController(parentView: self.navigationController?.view, title: "Text successfully sent!", level: SJNotificationLevelSuccess, position: SJNotificationPositionBottom, spinner: false).showFor(2)
        }
        else if result == MessageComposeResultFailed {
            SJNotificationViewController(parentView: self.navigationController?.view, title: "Text message failed", level: SJNotificationLevelError, position: SJNotificationPositionBottom, spinner: false).showFor(2)
        }
        
        //self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: - DELEGATE METHODS
    func didFetchCases(cases: [Case]) {
        self.refreshControl?.endRefreshing()
        EZLoadingActivity.hide()
        self.cases = cases
        self.updateAttendingCaseNumberBadge(cases.count)
        tableView.reloadData()
    }
    func failedToFetchCases(reason: String) {
        self.refreshControl?.endRefreshing()
        EZLoadingActivity.hide()
        SJNotificationViewController(parentView: self.navigationController?.view, title: reason, level: SJNotificationLevelMessage, position: SJNotificationPositionBottom, spinner: false).showFor(3)
    }
    
    func didSubmitCase(theCase: Case) {
        completedCase = theCase
        if let index = cases?.indexOf(theCase) {
            cases?.removeAtIndex(index)
            self.updateAttendingCaseNumberBadge(cases?.count)
            tableView.reloadData()
            if cases?.count == 0 {
                SJNotificationViewController(parentView: self.navigationController?.view, title: "You are all caught up!", level: SJNotificationLevelSuccess, position: SJNotificationPositionBottom, spinner: false).showFor(2)
                delay(2.0, closure: { () -> () in
                    self.showSmiley()
                })
            }
        }
    }
    
    func updateAttendingCaseNumberBadge(number: Int?) {
        if let badgeNumber = number {
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            app.attendingPendingCases = badgeNumber
        }
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
