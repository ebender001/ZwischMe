//
//  SignupViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/2/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UserSignupProtocol {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var username = ""
    var password = ""
    var email = ""
    var cellNumber = ""
    
    var warningMessagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = deepRedColor
        signupButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signupButton.backgroundColor = darkBlueColor
        signupButton.layer.cornerRadius = 5.0
        title = "Join Zwisch Me!!"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "info"), style: .Plain, target: self, action: "help:")
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Utilities
    func help(sender: AnyObject?) {
        self.performSegueWithIdentifier(signupHelpSegue, sender: nil)
    }
    
    func handleTap(tgr: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        spinner.startAnimating()
        if !allFieldsValid() {
            spinner.stopAnimating()
            return
        }
        let userSignUp = UserSignup(theEmail: email.lowercaseString, theCell: cellNumber, theUsername: username, thePassword: password)
        userSignUp.delegate = self
        userSignUp.checkUserAllowed()
    }

    //MARK: - validation
    func allFieldsValid() -> Bool {
        warningMessagesArray.removeAll()
        username = ""
        password = ""
        email = ""
        cellNumber = ""
        
        validateUsername()
        validatePassword()
        validateEmail()
        validateCellNumber()
        if warningMessagesArray.count > 0 {
            var msg = warningMessagesArray[0]
            for var i=1; i < warningMessagesArray.count; i++ {
                msg += ",\n\(warningMessagesArray[i])"
            }
            let alert = UIAlertController(title: "Data Error", message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false;
        }
        return true
    }
    func validateUsername() {
        if let text = usernameTextField.text {
            if text.characters.count < 6 {
                warningMessagesArray.append("Username must be at least 6 characters long")
            }
            else{
                username = text
            }
        }
    }
    
    func validatePassword() {
        if let text = passwordTextField.text {
            if text.characters.count < 8 {
                warningMessagesArray.append("Password must be at least 8 characters long")
            }
            else{
                password = text
            }
        }
    }
    
    func validateEmail() {
        if let text = emailTextField.text {
            let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            let success = emailTest.evaluateWithObject(text)
            if !success {
                warningMessagesArray.append("Please enter a valid email address")
            }
            else{
                email = text
            }
        }
    }
    
    func validateCellNumber() {
        if let text = cellphoneTextField.text {
            let adjustedText = adjustedCellNumber(text)
            if adjustedText.characters.count != 10 {
                warningMessagesArray.append("Please enter a valid cell phone number without any spaces, (), or -")
            }
            else{
                cellNumber = adjustedText
            }
        }
    }
    
    func adjustedCellNumber(originalNumber: String) -> String {
        var adjustedText = originalNumber.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        adjustedText = adjustedText.stringByReplacingOccurrencesOfString("(", withString: "")
        adjustedText = adjustedText.stringByReplacingOccurrencesOfString(")", withString: "")
        adjustedText = adjustedText.stringByReplacingOccurrencesOfString("-", withString: "")
        adjustedText = adjustedText.stringByReplacingOccurrencesOfString(" ", withString: "")
        return adjustedText
    }
    
    //MARK: - USER SIGNUP DELEGATE METHODS
    func didSignupAllowedUser(user: BackendlessUser) {
        //user is signed up, registered, and logged in
        spinner.stopAnimating()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: kHasSignedUp)
        defaults.synchronize()
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    func failedToSignupUser(reason: String) {
        spinner.stopAnimating()
        let alert = UIAlertController(title: "Signup Error", message: reason, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        
    }

}
