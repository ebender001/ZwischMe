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
    
    func startFetch() {
        let datastore = Backendless.sharedInstance().data.of(Case.ofClass())
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "attendingComplete = true"
        dataQuery.queryOptions.sortBy(["caseDate desc"])
        datastore.find(dataQuery, response: { (results: BackendlessCollection!) -> Void in
            if results.totalObjects == 0 {
                self.delegate?.failedToFetchCompletedCases("There are no completed cases.")
            }
            else{
                var unviewedArray = [Case]()
                var viewedArray = [Case]()
                if let allCases = results.getCurrentPage() as? [Case] {
                    for oneCase: Case in allCases {
                        if oneCase.viewedByResident {
                            viewedArray.append(oneCase)
                        }
                        else{
                            unviewedArray.append(oneCase)
                        }
                    }
                }
                self.delegate?.didFetchCompletedCases(unviewedArray, viewedCases: viewedArray)
            }
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToFetchCompletedCases(fault.message)
        }
    }
    
}
