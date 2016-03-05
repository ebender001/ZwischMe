//
//  UserLogout.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/4/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation

protocol UserLogoutProtocol {
    func didLogout(controller: UserLogout)
    func failedToLogout(reason: String, controller: UserLogout)
}

class UserLogout {
    
    var delegate: UserLogoutProtocol?
    
    func logout() {
        Backendless.sharedInstance().userService.logout({ (obj: AnyObject!) -> Void in
            self.delegate?.didLogout(self)
            }) { (fault: Fault!) -> Void in
                self.delegate?.failedToLogout(fault.message, controller: self)
        }
    }
    
}