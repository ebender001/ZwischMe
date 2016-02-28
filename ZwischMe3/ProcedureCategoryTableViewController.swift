//
//  ProcedureCategoryTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class ProcedureCategoryTableViewController: UITableViewController {
    var procedureTypeArray: [ProcedureCategory]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Procedure Type"
        let sd = NSSortDescriptor(key: "order", ascending: true)
        procedureTypeArray = (procedureTypeArray! as NSArray).sortedArrayUsingDescriptors([sd]) as? Array
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
        if let categoryArray = procedureTypeArray {
            return categoryArray.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ProcedureTypeCell, forIndexPath: indexPath)

        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.textColor = greenColor
        let oneType = procedureTypeArray![indexPath.row]
        cell.textLabel?.text = oneType.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let procedureType = procedureTypeArray![indexPath.row]
        Case.sharedInstance.procedureType = procedureType.name!
        let procedureDetails = procedureType.procedureDetails
        self.performSegueWithIdentifier(procedureDetailSegue, sender: procedureDetails)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == procedureDetailSegue {
            let vc = segue.destinationViewController as? ProcedureDetailsTableViewController
            vc?.procedureDetailsArray = (sender as? [ProcedureDetails])!
        }
    }

}
