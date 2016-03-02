//
//  AttendingCaseUpdater.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/2/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol AttendingCaseUpdaterProtocol {
    func didUpdateCase(theCase: Case)
    func failedToUpdateCase(reason: String)
}

class AttendingCaseUpdater {
    
    var delegate: AttendingCaseUpdaterProtocol?
    let theCase: Case
    
    init(caseToUpdate: Case) {
        theCase = caseToUpdate
    }
    
    func startFetch() {
        let datastore = Backendless.sharedInstance().data.of(Case.ofClass())
        datastore.save(theCase, response: { (result: AnyObject!) -> Void in
            self.delegate?.didUpdateCase(self.theCase)
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToUpdateCase(fault.message)
        }
    }
    
}