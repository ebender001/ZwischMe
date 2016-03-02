//
//  ZwischFetcher.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol ZwischFetcherProtocol {
    func didFetchZwisch(zwisch: [ZwischStage])
    func failedToFetchZwisch(reason: String)
}

class ZwischFetcher {
    
    var delegate: ZwischFetcherProtocol?
    
    func startFetch() {
        let datastore = Backendless.sharedInstance().data.of(ZwischStage.ofClass())
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions.sortBy(["order"])
        
        datastore.find(dataQuery, response: { (results: BackendlessCollection!) -> Void in
            if results.totalObjects == 0 {
                self.delegate?.failedToFetchZwisch("No Zwisch Stage available.")
            }
            else{
                var allZwisch = [ZwischStage]()
                if let z = results.getCurrentPage() as? [ZwischStage] {
                    for oneZ: ZwischStage in z {
                        allZwisch.append(oneZ)
                    }
                }
                self.delegate?.didFetchZwisch(allZwisch)
            }
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToFetchZwisch(fault.message)
        }
        
    }
}