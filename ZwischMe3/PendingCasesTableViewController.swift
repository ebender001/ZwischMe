//
//  PendingCasesTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class PendingCasesTableViewController: UITableViewController {
    
    var casesArray: [Case]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pending Cases"
        navigationController?.navigationBar.tintColor = mediumBlueColor
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
        if let casesArray = casesArray {
            return casesArray.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PendingCasesCell, forIndexPath: indexPath)
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.textColor = mediumBlueColor
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        
        cell.detailTextLabel?.textColor = greyColor
        cell.detailTextLabel?.numberOfLines = 0

        let oneCase = casesArray![indexPath.row]
        cell.textLabel?.text = oneCase.caseProcedureString()
        var attendingName = ""
        if let fullName = oneCase.attendingObject?.fullName() {
            attendingName = fullName
        }
        cell.detailTextLabel?.text = "\(attendingName) on \(oneCase.caseDateString())"

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65;
    }
}
