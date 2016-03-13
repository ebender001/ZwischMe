//
//  NewCaseTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit
import MessageUI

class NewCaseTableViewController: UITableViewController, PhysicianFetcherProtocol, SpecialtyFetcherProtocol, ZwischFetcherProtocol, ResidentSubmissionProtocol, MFMessageComposeViewControllerDelegate {
    let newCaseComponents = ["Date of Case", "Attending Surgeon", "Procedure", "Zwisch Stage", "Difficulty"]
    let theCase = Case.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Case"
        tableView.backgroundColor = greenColor
        self.navigationController?.navigationBar.tintColor = greenColor
        tableView.separatorStyle = .None
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //set residentObject and institutionObject
        initializeNewCase()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
        if theCase.caseComplete() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submitCase:")
        }
        else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func initializeNewCase() {
        let residentObject = currentAllowedUser()
        let institutionObject = residentObject.institution!
        theCase.institutionObject = institutionObject
        theCase.residentObject = residentObject
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newCaseComponents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewCaseCell, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        cell.accessoryType = .DisclosureIndicator

        let component = newCaseComponents[indexPath.row]
        cell.textLabel?.text = component
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        cell.detailTextLabel?.textColor = UIColor.yellowColor()
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        cell.detailTextLabel?.numberOfLines = 0
        
        switch indexPath.row {
        case 0:
            cell.detailTextLabel?.text = theCase.caseDateSummary
        case 1:
            if let attending = theCase.attendingObject {
                cell.detailTextLabel?.text = attending.fullName()
            }
            else{
                cell.detailTextLabel?.text = ""
            }
        case 2:
            var finalStr = ""
            let type = theCase.procedureType
            let detail = theCase.procedureDetail
            if type != "" && detail != "" {
                finalStr = "\(type): \(detail)"
            }
            if theCase.redo {
                finalStr = "\(finalStr), redo"
            }
            if theCase.minimallyInvasive {
                finalStr = "\(finalStr), minimally invasive"
            }
            cell.detailTextLabel?.text = finalStr
        case 3:
            cell.detailTextLabel?.text = theCase.residentZwischStage
        case 4:
            cell.detailTextLabel?.text = theCase.residentDifficulty
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = tableView.frame.size.height - (navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.size.height
        let numberComponents = newCaseComponents.count
        return height / CGFloat(numberComponents)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            //date
            performSegueWithIdentifier(caseDateSegue, sender: nil)
        case 1:
            //attendings
            fetchAttendings()
        case 2:
            //specialty
            fetchSpecialty()
        case 3:
            //zwisch
            fetchZwisch()
        case 4:
            self.performSegueWithIdentifier(difficultySegue, sender: nil)
        default:
            break
        }
    }
    
    //MARK: - SUBMIT
    func submitCase(sender: AnyObject?) {
        self.performSegueWithIdentifier(residentSubmitSegue, sender: nil)
    }
    
    //MARK: - NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == attendingSegue {
            let vc = segue.destinationViewController as? AttendingTableViewController
            vc?.attendingsArray = sender as? [AllowedUsers]
        }
        if segue.identifier == specialtySegue {
            let vc = segue.destinationViewController as? SpecialtyTableViewController
            vc?.specialtyArray = sender as? [Specialty]
        }
        if segue.identifier == zwischSegue {
            let vc = segue.destinationViewController as? ZwischTableViewController
            vc?.zwischArray = sender as? [ZwischStage]
        }
        if segue.identifier == residentSubmitSegue {
            let vc = segue.destinationViewController as? ResidentSubmitViewController
            vc?.delegate = self
        }
    }
    
    //MARK: - DATA FETCH
    func fetchAttendings() {
        EZLoadingActivity.show("Fetching...", disableUI: true)
        let physicianFetcher = PhysicianFetcher()
        physicianFetcher.delegate = self
        physicianFetcher.startFetch(isAttending: 1)
    }
    
    func fetchSpecialty() {
        EZLoadingActivity.show("Fetching...", disableUI: true)
        let specialtyFetcher = SpecialtyFetcher()
        specialtyFetcher.delegate = self
        specialtyFetcher.startFetch()
    }
    
    func fetchZwisch() {
        EZLoadingActivity.show("Fetching...", disableUI: true)
        let zwischFetcher = ZwischFetcher()
        zwischFetcher.delegate = self
        zwischFetcher.startFetch()
    }
    
    //MARK: - MESSAGING
    func sendMessage(theCase: Case) {
        if MFMessageComposeViewController.canSendText() {
            var cellNumber = ""
            var resident = ""
            if let number = theCase.attendingObject?.cellNumber {
                cellNumber = number
            }
            if let residentName = theCase.residentObject?.lastName {
                resident = "Dr. \(residentName)"
            }
            let mvc = MFMessageComposeViewController()
            mvc.messageComposeDelegate = self
            mvc.recipients = [cellNumber]
            mvc.body = "You have a new case to evaluate from \(resident) on the Zwisch Me app. Tap <a href='zwischmeApp://'></a>"
            self.presentViewController(mvc, animated: true, completion: nil)
        }
        else{
            let alert = showAlert(withTitle: "Text Message", withMessage: "This device can not send a text message")
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if result == MessageComposeResultSent {
            SJNotificationViewController(parentView: self.navigationController?.view, title: "Text successfully sent!", level: SJNotificationLevelSuccess, position: SJNotificationPositionBottom, spinner: false).showFor(2)
        }
        else if result == MessageComposeResultFailed {
            SJNotificationViewController(parentView: self.navigationController?.view, title: "Text message failed", level: SJNotificationLevelError, position: SJNotificationPositionBottom, spinner: false).showFor(2)
        }
    }
    
    //MARK: - PROTOCOL METHODS
    func didFetchPhysicians(physicians: [AllowedUsers]) {
        EZLoadingActivity.hide()
        self.performSegueWithIdentifier(attendingSegue, sender: physicians)
    }
    func failedToFetchPhysicians(reason: String) {
        EZLoadingActivity.hide()
        presentViewController(showAlert(withTitle: "Data Error", withMessage: reason), animated: true, completion: nil)
    }
    
    func didFetchSpecialties(specialties: [Specialty]) {
        EZLoadingActivity.hide()
        self.performSegueWithIdentifier(specialtySegue, sender: specialties)
    }
    func failedToFetchSpecialties(message: String) {
        EZLoadingActivity.hide()
        presentViewController(showAlert(withTitle: "Data Error", withMessage: message), animated: true, completion: nil)
    }
    
    func didFetchZwisch(zwisch: [ZwischStage]) {
        EZLoadingActivity.hide()
        self.performSegueWithIdentifier(zwischSegue, sender: zwisch)
    }
    func failedToFetchZwisch(reason: String) {
        EZLoadingActivity.hide()
        presentViewController(showAlert(withTitle: "Data Error", withMessage: reason), animated: true, completion: nil)
    }
    
    func didCompleteSubmission(theCase: Case) {
        let tempCase = Case()
        tempCase.residentObject = theCase.residentObject
        tempCase.attendingObject = theCase.attendingObject
        theCase.clearCase()
        SJNotificationViewController(parentView: self.navigationController!.view, title: "Successfully submitted your case.", level: SJNotificationLevelMessage, position: SJNotificationPositionBottom, spinner: false).showFor(2)
        delay(2.5) { () -> () in
            self.sendMessage(tempCase)
        }
        
    }
    func failedToSubmitCase(reason: String) {
        presentViewController(showAlert(withTitle: "Data Error", withMessage: reason), animated: true, completion: nil)
    }

}
