//
//  AttendingHomeCasesFetcher.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol AttendingHomeProtocol {
    func didFetchCases(cases: [Case])
    func failedToFetchCases(reason: String)
}

class AttendingHomeCasesFetcher {
    
    var delegate: AttendingHomeProtocol?
    let attendingObject = currentAllowedUser()
    
    func startFetch() {
        let datastore = Backendless.sharedInstance().data.of(Case.ofClass())
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions.sortBy(["caseDate desc"])
        let attendingId = attendingObject.objectId!
        dataQuery.whereClause = "attendingComplete = false and attendingObject.objectId = '\(attendingId)'"
        datastore.find(dataQuery, response: { (results: BackendlessCollection!) -> Void in
            if results.totalObjects == 0 {
                self.delegate?.failedToFetchCases("You are all caught up!")
            }
            else{
                var pendingCases = [Case]()
                if let allCases = results.getCurrentPage() as? [Case] {
                    for oneCase: Case in allCases {
                        pendingCases.append(oneCase)
                    }
                }
                self.delegate?.didFetchCases(pendingCases)
            }
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToFetchCases(fault.message)
        }
    }
}