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
                    registerForNotificationsAndEnterApp(self)
                }
            }
        }
    }
    
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
