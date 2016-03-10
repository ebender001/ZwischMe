//
//  CustomTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/7/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class CustomTableViewController: UITableViewController {
    
    func showScrollMessage() {
        let view = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height + 40.0, width: self.view.frame.size.width, height: 40.0))
        let initialFrame = view.frame
        var finalFrame = view.frame
        finalFrame.origin.y -= 80
        view.backgroundColor = mediumBlueColor
        view.textColor = UIColor.whiteColor()
        view.textAlignment = .Center
        view.text = "Scroll for More"
        view.font = UIFont.systemFontOfSize(16.0)
        self.navigationController?.view.addSubview(view)
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            view.frame = finalFrame
            }) { (action) -> Void in
                UIView.animateWithDuration(1.0, delay: 3.0, options: .CurveEaseIn, animations: { () -> Void in
                    view.frame = initialFrame
                    }, completion: { (action) -> Void in
                        view.removeFromSuperview()
                })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //will show scroll message for first three views
        //after that assume the user has learned to scroll
        let defaults = NSUserDefaults.standardUserDefaults()
        var userScrolled = defaults.integerForKey(kLearnScrolling)
        if userScrolled <= 3 {
            userScrolled++
            defaults.setInteger(userScrolled, forKey: kLearnScrolling)
            defaults.synchronize()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let userScrolled = NSUserDefaults.standardUserDefaults().integerForKey(kLearnScrolling)
        if tableView.contentSize.height > tableView.frame.size.height && userScrolled < 3 {
            showScrollMessage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
