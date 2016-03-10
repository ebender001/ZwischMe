//
//  AttendingCaseDetailViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit
import MessageUI

protocol AttendingCasesProtocol {
    func didSubmitCase(theCase: Case)
}

class AttendingCaseDetailViewController: UIViewController, AttendingCaseUpdaterProtocol {
    var theCase: Case?
    var keyboardIsVisible = false
    var originalViewFrame = CGRect.zero
    
    var delegate: AttendingCasesProtocol?

    @IBOutlet weak var caseDetailsLabel: UILabel!
    @IBOutlet weak var zwischStageSeg: UISegmentedControl!
    @IBOutlet weak var difficultySeg: UISegmentedControl!
    @IBOutlet weak var commentsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Case Summary"
        navigationController?.navigationBar.tintColor = purpleColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submit:")
        caseDetailsLabel.numberOfLines = 0
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Light", size: 9.0)!, forKey: NSFontAttributeName)
        zwischStageSeg.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
        difficultySeg.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
        zwischStageSeg.tintColor = purpleColor
        difficultySeg.tintColor = purpleColor
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        originalViewFrame = self.view.bounds
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        self.view.addGestureRecognizer(tap)
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tap(tgr: UITapGestureRecognizer?) {
        self.commentsTextView.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardIsVisible {
            keyboardIsVisible = true
            var newRect = originalViewFrame
            newRect.origin.y -= 200
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.view.frame = newRect
                }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardIsVisible {
            keyboardIsVisible = false
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                self.view.frame = self.originalViewFrame
                }, completion: nil)
        }
    }
    
    @IBAction func zwischInfoTapped(sender: AnyObject) {
        performSegueWithIdentifier(attendingZwischInfoSegue, sender: nil)
    }
    
    func submit(sender: AnyObject?) {
        tap(nil)
        theCase?.attendingComplete = 1
        var strZwisch = ""
        switch(zwischStageSeg.selectedSegmentIndex) {
        case 0:
            strZwisch = "Show and tell"
        case 1:
            strZwisch = "Active help"
        case 2:
            strZwisch = "Passive help"
        case 3:
            strZwisch = "Supervision only"
        default:
            break
        }
        theCase?.attendingZwischStage = strZwisch
        var strDifficulty = ""
        switch(difficultySeg.selectedSegmentIndex) {
        case 0:
            strDifficulty = "Easiest one-third"
        case 1:
            strDifficulty = "Average"
        case 2:
            strDifficulty = "Hardest one-third"
        default:
            break
        }
        theCase?.attendingDifficulty = strDifficulty
        var strComments = ""
        if commentsTextView.text.characters.count > 0 {
            strComments = " plus your comments"
            theCase?.attendingComments = commentsTextView.text
        }
        let msg = "Zwisch Stage: \(strZwisch), Difficulty: \(strDifficulty)\(strComments)."
        let alert = UIAlertController(title: "Submit Case?", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action -> Void in
            EZLoadingActivity.show("Saving...", disableUI: true)
            let updater = AttendingCaseUpdater(caseToUpdate: self.theCase!)
            updater.delegate = self
            updater.startFetch()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .Destructive, handler: { (action) -> Void in
            
        }))
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func configureUI() {
        var caseStr = ""
        if let theCase = theCase {
            caseStr = theCase.caseProcedureString()
        }
        caseStr += " on \((theCase?.caseDateString())!) (case #\((theCase?.caseOfDay)!))"
        if let fullName = theCase?.residentObject?.fullName() {
            caseStr += " with \(fullName)"
        }
        caseDetailsLabel.text = caseStr
        commentsTextView.layer.borderWidth = 1.0
        commentsTextView.layer.borderColor = purpleColor.CGColor
    }
    
    //MARK: - DELEGATE METHODS
    func didUpdateCase(theCase: Case) {
        EZLoadingActivity.hide()
        SJNotificationViewController(parentView: self.navigationController?.view, title: "Successfully submitted the case.", level: SJNotificationLevelMessage, position: SJNotificationPositionBottom, spinner: false).showFor(2)
        delay(2.5) { () -> () in
            self.delegate?.didSubmitCase(theCase)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    func failedToUpdateCase(reason: String) {
        EZLoadingActivity.hide()
        SJNotificationViewController(parentView: self.navigationController?.view, title: reason, level: SJNotificationLevelError, position: SJNotificationPositionBottom, spinner: false).showFor(3)
    }

}
