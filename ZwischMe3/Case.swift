//
//  Case.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

class Case: NSObject{
    
    static let sharedInstance = Case()
    
    var objectId = ""
    var created: NSDate?
    var updated: NSDate?
    var caseDate: NSDate?
    var caseOfDay: Int = 1
    var procedureType = ""
    var procedureDetail = ""
    var redo: Int = 0
    var minimallyInvasive: Int = 0
    var residentZwischStage = ""
    var residentDifficulty = ""
    var attendingZwischStage = ""
    var attendingDifficulty = ""
    var attendingComments = ""
    var attendingComplete: Int = 0
    var attendingObject: AllowedUsers?
    var institutionObject: Institution?
    var residentObject: AllowedUsers?
    var viewedByResident: Int = 0
    var caseDateSummary = ""
}

extension Case: NSCopying {
    func clearCase() {
        objectId = ""
        created = nil
        updated = nil
        caseDate = nil
        caseOfDay = 1
        procedureType = ""
        procedureDetail = ""
        redo = 0
        minimallyInvasive = 0
        residentZwischStage = ""
        residentDifficulty = ""
        attendingZwischStage = ""
        attendingDifficulty = ""
        attendingComments = ""
        attendingComplete = 0
        attendingObject = nil
        institutionObject = nil
        residentObject = nil
        viewedByResident = 0
        caseDateSummary = ""
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return Case()
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
    
    func caseProcedureString() -> String {
        var detail = procedureDetail
        var str = "\(procedureType): "
        if redo == 1 {
            str += "Redo "
            detail = detail.lowercaseString
        }
        str += detail
        if minimallyInvasive == 1 {
            str += " (minimally invasive)"
        }
        return str
    }
    
    func caseComplete() -> Bool {
        if attendingObject != nil && procedureType != "" && procedureDetail != "" && residentZwischStage != "" && residentDifficulty != "" {
            return true
        }
        return false
    }
}
