//
//  SpecialtyTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class SpecialtyTableViewController: UITableViewController {
    var specialtyArray: [Specialty]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Specialty"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
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
        if let specialtyArray = specialtyArray {
            return specialtyArray.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SpecialtyCell, forIndexPath: indexPath)

        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.textColor = greenColor
        let oneSpecialty = specialtyArray![indexPath.row]
        cell.textLabel?.text = oneSpecialty.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let specialty = specialtyArray![indexPath.row]
        let procedureCategory = specialty.procedureCategory
        self.performSegueWithIdentifier(procedureTypeSegue, sender: procedureCategory)
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = tableView.frame.size.height - (navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.size.height
        let numberComponents = specialtyArray!.count
        return height / CGFloat(numberComponents)
    }
    
    //MARK: - NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == procedureTypeSegue {
            let vc = segue.destinationViewController as? ProcedureCategoryTableViewController
            vc?.procedureTypeArray = sender as? [ProcedureCategory]
        }
    }

}
