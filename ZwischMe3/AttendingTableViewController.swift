//
//  AttendingTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class AttendingTableViewController: UITableViewController {
    var attendingsArray: [AllowedUsers]?
    var selectedAttendingIndex: Int?
    var selectedAttending: AllowedUsers?
    let currentCase = Case.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        title = "Select Attending"
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Case.sharedInstance.attendingObject = selectedAttending
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let attendingsArray = attendingsArray {
            return attendingsArray.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AttendingCell, forIndexPath: indexPath)

        let oneAttending = attendingsArray![indexPath.row]
        cell.textLabel?.text = oneAttending.fullName()
        cell.textLabel?.textColor = greenColor

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedAttending = attendingsArray![indexPath.row]
        delay(0.4) { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}
