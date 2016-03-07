//
//  CaseSubmitter.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol CaseSubmitterProtocol {
    func didSaveCase(theCase: Case)
    func failedToSaveCase(reason: String)
}

class CaseSubmitter {
    
    var delegate: CaseSubmitterProtocol?

    func save() {
        
        let datastore = Backendless.sharedInstance().data.of(Case.ofClass())
        let theCase = Case.sharedInstance
        
        datastore.save(theCase, response: { (result: AnyObject!) -> Void in
            print("Case saved")
            self.delegate?.didSaveCase(theCase)
            }) { (fault: Fault!) -> Void in
                print("Error: \(fault.message)")
                self.delegate?.failedToSaveCase(fault.message)
        }
    }

}