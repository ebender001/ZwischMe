//
//  Functions.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import Foundation
import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func currentAllowedUser() -> AllowedUsers {
    return Backendless.sharedInstance().userService.currentUser.getProperty("allowedUser") as! AllowedUsers
}

func showAlert(withTitle title: String, withMessage message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
    return alert
}

func registerForNotificationsAndEnterApp(controller: UIViewController) {
    let defaults = NSUserDefaults.standardUserDefaults()
    var role = ""
    let allowedUser = Backendless.sharedInstance().userService.currentUser.getProperty("allowedUser") as! AllowedUsers
    if allowedUser.attending == true {
        role = "attending"
    }
    else if allowedUser.attending == false {
        role = "resident"
    }
    if defaults.boolForKey(kRegisterForNotification) == false {
        var msg = "You will be asked to allow notifications. "
        if role == "attending" {
            msg += "This will allow a badge to be placed on the app icon to inform you of pending cases to review. There will be no annoying sounds or messages."
        }
        else if role == "resident" {
            msg += "You will be able to automatically update your attending's app badge with cases to complete."
        }
        let alert = UIAlertController(title: "Notifications", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: { (action) -> Void in
            let userNotificationTypes = UIUserNotificationType.Badge
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            let application = UIApplication.sharedApplication()
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            if role == "attending" {
                controller.performSegueWithIdentifier(attendingStartSegue, sender: nil)
            }
            else if role == "resident" {
                controller.performSegueWithIdentifier(residentStartSegue, sender: nil)
            }
            
        }))
        controller.presentViewController(alert, animated: true, completion: nil)
        defaults.setBool(true, forKey: kRegisterForNotification)
        defaults.synchronize()
    }
    else{
        if role == "attending" {
            controller.performSegueWithIdentifier(attendingStartSegue, sender: nil)
        }
        else if role == "resident" {
            controller.performSegueWithIdentifier(residentStartSegue, sender: nil)
        }
    }
    
}