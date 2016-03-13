//
//  RedoViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

protocol RedoProtocol {
    func didDismiss(controller: RedoViewController)
}

class RedoViewController: UIViewController {
    var delegate: RedoProtocol?
    @IBOutlet weak var redoSwitch: UISwitch!
    @IBOutlet weak var minimallyInvasiveSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        redoSwitch.tintColor = greenColor
        minimallyInvasiveSwitch.tintColor = greenColor
        
        if Case.sharedInstance.redo {
            redoSwitch.on = true
        }
        else{
            redoSwitch.on = false
        }
        
        if Case.sharedInstance.minimallyInvasive {
            minimallyInvasiveSwitch.on = true
        }
        else{
            minimallyInvasiveSwitch.on = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        Case.sharedInstance.redo = redoSwitch.on ? true : false
        Case.sharedInstance.minimallyInvasive = minimallyInvasiveSwitch.on ? true : false
        self.delegate?.didDismiss(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
