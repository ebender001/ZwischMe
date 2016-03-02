//
//  CaseUpdater.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

class CaseUpdater {
    let theCase: Case
    
    init(theCase: Case) {
        self.theCase = theCase
        
    }
    
    func updateAfterResidentView() {
        let datastore = Backendless.sharedInstance().data.of(Case.ofClass())
        theCase.viewedByResident = true
        datastore.save(theCase)
    }
}