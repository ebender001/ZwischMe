//
//  CompletedCasesFetcher.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol CompletedCasesFetcherProtocol {
    func didFetchCompletedCases(unviewedCases: [Case], viewedCases: [Case])
    func failedToFetchCompletedCases(reason: String)
}

class CompletedCasesFetcher {
    var delegate: CompletedCasesFetcherProtocol?
    let user = currentAllowedUser()
    var unviewedArray = [Case]()
    var viewedArray = [Case]()
    
    func startFetch() {
        let datastore = Backendless.sharedInstance().data.of(Case.ofClass())
        let dataQuery = BackendlessDataQuery()
        let institution = user.institution!
        let institutionId = institution.objectId!
        let residentObjectId = user.objectId!
        dataQuery.whereClause = "attendingComplete = true and institutionObject.objectId = '\(institutionId)' and residentObject.objectId = '\(residentObjectId)'"
        dataQuery.queryOptions.sortBy(["caseDate desc"])
        dataQuery.queryOptions.pageSize = 100
        datastore.find(dataQuery, response: { (results: BackendlessCollection!) -> Void in
            if results.totalObjects == 0 {
                self.delegate?.failedToFetchCompletedCases("There are no completed cases.")
            }
            else{
                self.nextPage(results!)
//                if let allCases = results.getCurrentPage() as? [Case] {
//                    for oneCase: Case in allCases {
//                        if oneCase.viewedByResident {
//                            self.viewedArray.append(oneCase)
//                        }
//                        else{
//                            self.unviewedArray.append(oneCase)
//                        }
//                    }
//                }
//                while results.nextPage() != nil {
//                    if results.getCurrentPage().count == 0 {
//                        break
//                    }
//                    if let moreCases = results.getCurrentPage() as? [Case] {
//                        for oneCase: Case in moreCases {
//                            if oneCase.viewedByResident {
//                                self.viewedArray.append(oneCase)
//                            }
//                            else{
//                                self.unviewedArray.append(oneCase)
//                            }
//                        }
//                    }
//                }
                self.delegate?.didFetchCompletedCases(self.unviewedArray, viewedCases: self.viewedArray)
            }
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToFetchCompletedCases(fault.message)
        }
    }
    
    func nextPage(cases: BackendlessCollection) {
        let size = cases.getCurrentPage().count
        if size == 0 {
            return
        }
        if let allCases = cases.getCurrentPage() as? [Case] {
            for oneCase: Case in allCases {
                if oneCase.viewedByResident {
                    self.viewedArray.append(oneCase)
                }
                else{
                    self.unviewedArray.append(oneCase)
                }
            }
        }
        
        cases.nextPageAsync({ (theCases: BackendlessCollection!) -> Void in
            self.nextPage(theCases)
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToFetchCompletedCases(fault.message)
        }
    }
    
}
