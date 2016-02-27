//
//  NewCaseTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class NewCaseTableViewController: UITableViewController {
    let newCaseComponents = ["Date of Case", "Attending Surgeon", "Procedure", "Zwisch Stage", "Difficulty"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Case"
        tableView.backgroundColor = greenColor
        self.navigationController?.navigationBar.tintColor = greenColor
        tableView.separatorStyle = .None
        
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
        return newCaseComponents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewCaseCell, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        cell.accessoryType = .DisclosureIndicator

        let component = newCaseComponents[indexPath.row]
        cell.textLabel?.text = component
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        cell.detailTextLabel?.textColor = UIColor.yellowColor()
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        cell.detailTextLabel?.numberOfLines = 0

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = tableView.frame.size.height - (navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.size.height
        let numberComponents = newCaseComponents.count
        return height / CGFloat(numberComponents)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            //date
            performSegueWithIdentifier(caseDateSegue, sender: nil)
        default:
            break
        }
    }

}
