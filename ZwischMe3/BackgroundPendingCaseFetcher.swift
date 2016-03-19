//
//  BackgroundAttendingCaseFetcher.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/17/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation
import UIKit

class BackgroundPendingCaseFetcher {
    let userObject: AllowedUsers
    let completionHandler: (UIBackgroundFetchResult) -> Void
    
    init(attending: AllowedUsers, handler: (UIBackgroundFetchResult) -> Void) {
        userObject = attending
        completionHandler = handler
    }
    
//    func startFetch() {
//        if let attendingId = userObject.objectId {
//            let datastore = Backendless.sharedInstance().data.of(Case.ofClass())
//            let dataQuery = BackendlessDataQuery()
//            dataQuery.queryOptions.sortBy(["caseDate desc"])
//            dataQuery.whereClause = "attendingComplete = false and attendingObject.objectId = '\(attendingId)'"
//            datastore.find(dataQuery, response: { (results: BackendlessCollection!) -> Void in
//                if results.totalObjects == 0 {
//                    self.completionHandler(.NewData)
//                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
//                }
//                else{
//                    self.completionHandler(.NewData)
//                    UIApplication.sharedApplication().applicationIconBadgeNumber = results.totalObjects.integerValue
//                }
//                }) { (fault: Fault!) -> Void in
//                    self.completionHandler(.Failed)
//                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
//            }
//        }
//    }
    
    func startFetch() {
        if let attendingId = userObject.objectId {
            let datastore = Backendless.sharedInstance().data.of(Case.ofClass())
            let dataQuery = BackendlessDataQuery()
            dataQuery.queryOptions.sortBy(["caseDate desc"])
            if userObject.attending {
                dataQuery.whereClause = "attendingComplete = false and attendingObject.objectId = '\(attendingId)'"
            }
            else {
                //resident notified of all pending cases
                dataQuery.whereClause = "attendingComplete = false"
            }
            
            datastore.find(dataQuery, response: { (results: BackendlessCollection!) -> Void in
                if results.totalObjects == 0 {
                    self.completionHandler(.NewData)
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                }
                else{
                    self.completionHandler(.NewData)
                    UIApplication.sharedApplication().applicationIconBadgeNumber = results.totalObjects.integerValue
                }
                }) { (fault: Fault!) -> Void in
                    self.completionHandler(.Failed)
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            }
        }
    }
}
