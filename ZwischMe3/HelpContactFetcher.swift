//
//  HelpContact.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/13/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol HelpContactFetcherProtocol {
    func didFetchHelpContact(email: String)
    func failedToFetchHelpContact(reason: String)
}

class HelpContactFetcher {
    var delegate: HelpContactFetcherProtocol?
    
    func fetchHelp() {
        let datastore = Backendless.sharedInstance().data.of(HelpContact.ofClass())
        datastore.find({ (results: BackendlessCollection!) -> Void in
            if results.totalObjects == 0 {
                self.delegate?.failedToFetchHelpContact("Failed to fetch Help email address. Please send email directly to info@cvoffice.com")
            }
            else{
                if let objects = results.getCurrentPage() as? [HelpContact] {
                    let email = objects.first!
                    self.delegate?.didFetchHelpContact(email.email)
                }
                else{
                    self.delegate?.failedToFetchHelpContact("Failed to fetch Help email address. Please send email directly to info@cvoffice.com")
                }
            }
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToFetchHelpContact(fault.message)
        }
    }
}
