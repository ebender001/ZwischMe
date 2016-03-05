//
//  StartViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/2/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        delay(0.5) { () -> () in
            if defaults.boolForKey(kHasSignedUp) == false {
                //perform signup since has never done so on this device
                self.performSegueWithIdentifier(signupSegue, sender: nil)
            }
            else{
                let user = Backendless.sharedInstance().userService.currentUser
                if user == nil {
                    //perform login
                    print("login")
                    self.performSegueWithIdentifier(loginSegue, sender: nil)
                }
                else{
                    registerForNotifications(self)
                }
            }
        }
    }
    /*
    func registerForNotifications() {
        let defaults = NSUserDefaults.standardUserDefaults()
//        let role = NSUserDefaults.standardUserDefaults().stringForKey(kRole)
        var role = ""
        let user = Backendless.sharedInstance().userService.currentUser
        let allowedUser = user.getProperty("allowedUser") as? AllowedUsers
        let attending = allowedUser?.attending
        if attending! {
            role = "attending"
        }
        else{
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
                    self.performSegueWithIdentifier(attendingStartSegue, sender: nil)
                }
                else if role == "resident" {
                    self.performSegueWithIdentifier(residentStartSegue, sender: nil)
                }
//                if let role = defaults.stringForKey(kRole) {
//                    if role == "attending" {
//                        self.performSegueWithIdentifier(attendingStartSegue, sender: nil)
//                    }
//                    else if role == "resident" {
//                        self.performSegueWithIdentifier(residentStartSegue, sender: nil)
//                    }
//                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            defaults.setBool(true, forKey: kRegisterForNotification)
            defaults.synchronize()
        }
        else{
            if role == "attending" {
                self.performSegueWithIdentifier(attendingStartSegue, sender: nil)
            }
            else if role == "resident" {
                self.performSegueWithIdentifier(residentStartSegue, sender: nil)
            }
        }
    }
    */
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator()
    }

}
