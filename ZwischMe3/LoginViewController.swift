//
//  LoginViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/4/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, ForgotPasswordProtocol, UserSignupProtocol {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.tintColor = deepRedColor
        loginButton.backgroundColor = mediumBlueColor
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.layer.cornerRadius = 5.0
        forgotPasswordButton.setTitleColor(deepRedColor, forState: .Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "info"), style: .Plain, target: self, action: "help:")
        title = "Log In"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func help(sender: AnyObject?) {
        self.performSegueWithIdentifier(loginHelpSegue, sender: nil)
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        EZLoadingActivity.show("Logging in...", disableUI: true)
        let userSignup = UserSignup(theEmail: usernameTextField.text!, theCell: passwordTextField.text!, theUsername: "", thePassword: "")
        userSignup.delegate = self
        userSignup.loginUser(usernameTextField.text!, password: passwordTextField.text!)
    }

    @IBAction func forgotPasswordTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Reset Password", message: "", preferredStyle: .Alert)
        let positiveAction = UIAlertAction(title: "Reset", style: .Default) { (action) -> Void in
            EZLoadingActivity.show("Restore password...", disableUI: true)
            let emailTextField = alert.textFields![0] as UITextField
            let pwdReset = ForgotPassword(theEmail: emailTextField.text!)
            pwdReset.delegate = self
            pwdReset.recoverPassword()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter your user name."
            textField.keyboardType = .EmailAddress
        
        }
        alert.addAction(positiveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - DELEGATE METHODS
    func didRestorPassword(controller: ForgotPassword) {
        EZLoadingActivity.hide()
        controller.delegate = nil
        SJNotificationViewController(parentView: self.navigationController?.view, title: "Check your email for password reset.", level: SJNotificationLevelMessage, position: SJNotificationPositionBottom, spinner: false).showFor(3)
    }
    func failedToRestorePassword(reason: String, controller: ForgotPassword) {
        EZLoadingActivity.hide()
        controller.delegate = nil
        SJNotificationViewController(parentView: self.navigationController?.view, title: "Failed! Please recheck email input.", level: SJNotificationLevelError, position: SJNotificationPositionBottom, spinner: false).showFor(3)
    }
    
    func didSignupAllowedUser(user: BackendlessUser) {
        EZLoadingActivity.hide()
        self.navigationController?.popViewControllerAnimated(true)
    }
    func failedToSignupUser(reason: String) {
        EZLoadingActivity.hide()
        let alert = UIAlertController(title: "Login Error", message: reason, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

}
