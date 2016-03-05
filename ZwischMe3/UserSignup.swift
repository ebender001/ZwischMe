//
//  UserChecker.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/2/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol UserSignupProtocol {
    func didSignupAllowedUser(user: BackendlessUser)
    func failedToSignupUser(reason: String)
}

class UserSignup: NSObject {
    var delegate: UserSignupProtocol?
    
    var email: String
    var cellNumber: String
    var username: String
    var password: String
    
    init(theEmail: String, theCell: String, theUsername: String, thePassword: String) {
        email = theEmail
        cellNumber = theCell
        username = theUsername
        password = thePassword
        super.init()
    }
    
    func checkUserAllowed() {
        let datastore = Backendless.sharedInstance().data.of(AllowedUsers.ofClass())
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "email = '\(email)' and cellNumber = '\(cellNumber)'"
        datastore.find(dataQuery, response: { (results: BackendlessCollection!) -> Void in
            if results.totalObjects == 0 {
                print("This user has not been registered.")
                self.delegate?.failedToSignupUser("This user has not been registered.")
            }
            else{
                let physicians = results.getCurrentPage()
                let onePhysician = physicians.first as! AllowedUsers
                self.register(onePhysician)
            }
            }) { (fault: Fault!) -> Void in
                print(fault.message)
                self.delegate?.failedToSignupUser(fault.message)
        }
    }
    
    func register(theUser: AllowedUsers) {
        let user = BackendlessUser()
        let backendless = Backendless.sharedInstance()
        user.email = theUser.email!
        user.password = password
        user.setProperty("username", object: username)
        user.setProperty("cellNumber", object: theUser.cellNumber!)
        user.setProperty("allowedUser", object: theUser)
        backendless.userService.registering(user, response: { (registeredUser: BackendlessUser!) -> Void in
            self.loginUser(self.username, password: self.password)
            print("Registered")
            }) { (fault: Fault!) -> Void in
                if fault.faultCode == "3033" {
                    //already registered
                    //therefore, try login
                    self.loginUser(self.username, password: self.password)
                }
                else{
                    self.delegate?.failedToSignupUser(fault.message)
                    print(fault.message)
                }
        }
    }
    
    func loginUser(username: String, password: String) {
        Backendless.sharedInstance().userService.login(username, password: password, response: { (user: BackendlessUser!) -> Void in
            self.delegate?.didSignupAllowedUser(user)
            
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToSignupUser(fault.message)
        }
    }
}