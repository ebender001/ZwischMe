//
//  SpecialtyFetcher.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol SpecialtyFetcherProtocol {
    func didFetchSpecialties(specialties: [Specialty])
    func failedToFetchSpecialties(message: String)
}

class SpecialtyFetcher {
    var delegate: SpecialtyFetcherProtocol?
    
    func startFetch() {
        let datastore = Backendless.sharedInstance().data.of(Specialty.ofClass())
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions.sortBy(["order"])
        
        datastore.find(dataQuery, response: { (results: BackendlessCollection!) -> Void in
            if results.totalObjects == 0 {
                self.delegate?.failedToFetchSpecialties("There were no specialties listed.")
            }
            else{
                var allSpecialties = [Specialty]()
                if let sp = results.getCurrentPage() as? [Specialty] {
                    for oneSpecialty: Specialty in sp {
                        allSpecialties.append(oneSpecialty)
                    }
                    self.delegate?.didFetchSpecialties(allSpecialties)
                }
            }
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToFetchSpecialties(fault.message)
        }
    }
}