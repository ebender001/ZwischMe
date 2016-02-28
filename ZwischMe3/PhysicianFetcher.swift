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
    
    func startFetch(isAttending: Bool) {
        let datastore = Backendless.sharedInstance().data.of(AllowedUsers.ofClass())
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "attending = true"
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