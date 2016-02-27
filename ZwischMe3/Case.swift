//
//  Case.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

class Case: NSObject {
    
    static let sharedInstance = Case()
    
    var objectId = ""
    var created: NSDate?
    var updated: NSDate?
    var caseDate: NSDate?
    var caseOfDay = 1
    var procedureType = ""
    var procedureDetail = ""
    var redo = false
    var minimallyInvasive = false
    var residentZwischStage = ""
    var residentDifficulty = ""
    var attendingZwischStage = ""
    var attendingDifficulty = ""
    var attendingComments = ""
    var attendingComplete = false
    var attendingObject: AllowedUser?
    var institutionObject: Institution?
    var residentObject: AllowedUser?
    var viewedByResident = false
}

extension Case {
    func clearCase() {
        objectId = ""
        created = nil
        updated = nil
        caseDate = nil
        caseOfDay = 1
        procedureType = ""
        procedureDetail = ""
        redo = false
        minimallyInvasive = false
        residentZwischStage = ""
        residentDifficulty = ""
        attendingZwischStage = ""
        attendingDifficulty = ""
        attendingComments = ""
        attendingComplete = false
        attendingObject = nil
        institutionObject = nil
        residentObject = nil
        viewedByResident = false
    }
    
    func caseDateString() -> String {
        if let caseDate = caseDate {
            let df = NSDateFormatter()
            df.dateStyle = .MediumStyle
            df.timeStyle = .NoStyle
            return df.stringFromDate(caseDate)
        }
        return ""
    }
    
    func caseComplete() -> Bool {
        if attendingObject != nil && procedureType != "" && procedureDetail != "" && residentZwischStage != "" && residentDifficulty != "" {
            return true
        }
        return false
    }
}
