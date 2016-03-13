//
//  PendingCaseDetailViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class PendingCaseDetailViewController: UIViewController {
    var theCase: Case?

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Case Details"
        webView.loadHTMLString(htmlString(), baseURL: NSBundle.mainBundle().bundleURL)
        
        if let caseDate = theCase?.caseDate {
            let interval = caseDate.timeIntervalSinceNow
            if interval < -60*60*24*2 {
                //case pending more than 2 days
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remind", style: .Plain, target: self, action: "remind:")
            }
            else{
                navigationItem.rightBarButtonItem = nil
            }
        }
        
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
        if theCase!.redo {
            str += " (Redo)"
        }
        if theCase!.minimallyInvasive {
            str += " (Minimally Invasive)"
        }
        str += "</td></tr>"
        str += "<tr><td class='label'>Zwisch Stage:</td>"
        str += "<td class='data'>\(theCase!.residentZwischStage)</td></tr>"
        str += "<tr><td class='label'>Difficulty:</td>"
        str += "<td class='data'>\(theCase!.residentDifficulty)</td></tr>"
        
        str += "</table></body></html>"
        
        return str
    }
}
