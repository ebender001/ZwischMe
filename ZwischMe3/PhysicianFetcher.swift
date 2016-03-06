//
//  AttendingFetcher.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol PhysicianFetcherProtocol {
    func didFetchPhysicians(physicians: [AllowedUsers])
    func failedToFetchPhysicians(reason: String);
}

class PhysicianFetcher {
    var delegate: PhysicianFetcherProtocol?
    let user = currentAllowedUser()
    
    func startFetch(isAttending attending: Bool) {
        let datastore = Backendless.sharedInstance().data.of(AllowedUsers.ofClass())
        let dataQuery = BackendlessDataQuery()
        let institution = user.institution!
        let institutionId = institution.objectId!
        dataQuery.whereClause = "active = true and attending = \(attending) and institution.objectId = '\(institutionId)'"
        var allPhysicians = [AllowedUsers]()
        datastore.find(dataQuery, response: { (result:BackendlessCollection!) -> Void in
            if result.totalObjects == 0 {
                self.delegate?.failedToFetchPhysicians("There are no physicians available.")
            }
            else{
                let physicians = result.getCurrentPage()
                for onePhysician: AllowedUsers in (physicians as? [AllowedUsers])! {
                    allPhysicians.append(onePhysician)
                }
                //add paging
                self.delegate?.didFetchPhysicians(allPhysicians)
            }
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToFetchPhysicians(fault.message)
        }
    }
}