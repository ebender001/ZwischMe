//
//  ForgotPassword.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/4/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol ForgotPasswordProtocol {
    func didRestorPassword(controller: ForgotPassword)
    func failedToRestorePassword(reason: String, controller: ForgotPassword)
}

class ForgotPassword {
    
    var delegate: ForgotPasswordProtocol?
    let email: String
    
    init(theEmail: String) {
        email = theEmail
    }
    
    func recoverPassword() {
        Backendless.sharedInstance().userService.restorePassword(self.email, response: { (result: AnyObject!) -> Void in
            self.delegate?.didRestorPassword(self)
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToRestorePassword(fault.message, controller: self)
        }
    }
}