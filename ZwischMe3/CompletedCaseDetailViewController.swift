//
//  CompletedCaseDetailViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class CompletedCaseDetailViewController: UIViewController {

    var theCase: Case?
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Case Details"
        webView.loadHTMLString(htmlString(), baseURL: NSBundle.mainBundle().bundleURL)
        
    }
    
    func remind(sender: AnyObject?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func htmlString() -> String {
        
        var str = "<html><head><link rel='stylesheet' type='text/css' href='style.css'></head><body>"
        str += "<table><tr><td class='label'>Date of case:</td><td class='data'>"
        str += theCase!.caseDateString()
        str += "</td></tr>"
        str += "<tr><td class='label'>Case of day:</td><td class='data'>\(Case.sharedInstance.caseOfDay)</td></tr>"
        str += "<tr><td class='label'>Attending:</td>"
        if let attendingObject = theCase!.attendingObject {
            str += "<td class='data'> \(attendingObject.fullName())"
        }
        str += "</td></tr>"
        str += "<tr><td class='label'>Procedure Type:</td>"
        str += "<td class='data'>\(theCase!.procedureType)</td></tr>"
        str += "<tr><td class='label'>Procedure Detail:</td>"
        str += "<td class='data'>\(theCase!.procedureDetail)"
        if theCase!.redo == 1 {
            str += " (Redo)"
        }
        if theCase!.minimallyInvasive == 1 {
            str += " (Minimally Invasive)"
        }
        str += "</td></tr>"
        str += "<tr><td class='label'>Zwisch Stage:</td>"
        str += "<td class='data'>\(theCase!.residentZwischStage)</td></tr>"
        str += "<tr><td class='label'>Difficulty:</td>"
        str += "<td class='data'>\(theCase!.residentDifficulty)</td></tr>"
        str += "<tr><td class='label'>Attending Zwisch Stage:</td>"
        str += "<td class='data'>\(theCase!.attendingZwischStage)</td></tr>"
        str += "<tr><td class='label'>Attending Difficulty:</td>"
        str += "<td class='data'>\(theCase!.attendingDifficulty)</td></tr>"
        str += "<tr><td class='label'>Attending Comments:</td>"
        str += "<td class='data'>\(theCase!.attendingComments)</td></tr>"
        
        str += "</table></body></html>"
        
        return str
    }

}
