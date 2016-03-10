//
//  AllowedUser.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

class AllowedUsers: NSObject {
    var cellNumber: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var institutionId: String?
    var attending: Int = 0
    var active: Int = 0
    var objectId: String?
    var institution: Institution?
    
    
}

extension AllowedUsers {
    func fullName() -> String {
        var str = ""
        if let firstName = firstName {
            str += "Dr. " + firstName
            if let lastName = lastName {
                str += " " + lastName
            }
        }
        return str
    }
}
