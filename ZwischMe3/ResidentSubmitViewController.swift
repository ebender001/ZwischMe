//
//  ResidentSubmitViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

protocol ResidentSubmissionProtocol {
    func didCompleteSubmission(theCase: Case)
    func failedToSubmitCase(reason: String)
}

class ResidentSubmitViewController: UIViewController, CaseSubmitterProtocol {

    var delegate: ResidentSubmissionProtocol?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.loadHTMLString(htmlString(), baseURL: NSBundle.mainBundle().bundleURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func htmlString() -> String {
        let theCase = Case.sharedInstance
        
        var str = "<html><head><link rel='stylesheet' type='text/css' href='style.css'></head><body>"
        str += "<table><tr><td class='label'>Date of case:</td><td class='data'>"
        str += theCase.caseDateString()
        str += "</td></tr>"
        str += "<tr><td class='label'>Case of day:</td><td class='data'>\(Case.sharedInstance.caseOfDay)</td></tr>"
        str += "<tr><td class='label'>Attending:</td>"
        if let attendingObject = theCase.attendingObject {
            str += "<td class='data'> \(attendingObject.fullName())"
        }
        str += "</td></tr>"
        str += "<tr><td class='label'>Procedure Type:</td>"
        str += "<td class='data'>\(theCase.procedureType)</td></tr>"
        str += "<tr><td class='label'>Procedure Detail:</td>"
        str += "<td class='data'>\(theCase.procedureDetail)"
        if theCase.redo {
            str += " (Redo)"
        }
        if theCase.minimallyInvasive {
            str += " (Minimally Invasive)"
        }
        str += "</td></tr>"
        str += "<tr><td class='label'>Zwisch Stage:</td>"
        str += "<td class='data'>\(theCase.residentZwischStage)</td></tr>"
        str += "<tr><td class='label'>Difficulty:</td>"
        str += "<td class='data'>\(theCase.residentDifficulty)</td></tr>"
        
        str += "</table></body></html>"
        
        return str
    }
    
    @IBAction func submitTapped(sender: AnyObject) {
        EZLoadingActivity.show("Submitting...", disableUI: true)
        let submitter = CaseSubmitter()
        submitter.delegate = self
        submitter.save()
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - DELEGATE METHODS
    func didSaveCase(theCase: Case) {
        EZLoadingActivity.hide()
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.didCompleteSubmission(theCase)
    }
    func failedToSaveCase(reason: String) {
        EZLoadingActivity.hide()
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.failedToSubmitCase(reason)
    }

}
