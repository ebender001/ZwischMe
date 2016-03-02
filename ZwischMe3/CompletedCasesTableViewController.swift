//
//  CompletedCasesTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/28/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class CompletedCasesTableViewController: UITableViewController {
    var unViewedCases: [Case]?
    var viewedCases: [Case]?
    var caseListDirty = false

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Completed Cases"
        navigationController?.navigationBar.tintColor = purpleColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if caseListDirty {
            caseListDirty = false
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //unviewed cases
            if let unViewedCases = unViewedCases {
                return unViewedCases.count
            }
            else{
                return 0
            }
        }
        if section == 1 {
            //viewed cases
            if let viewedCases = viewedCases {
                return viewedCases.count
            }
            else{
                return 0
            }
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CompletedCasesCell, forIndexPath: indexPath)

        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.textColor = purpleColor
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        
        cell.detailTextLabel?.textColor = greyColor
        cell.detailTextLabel?.numberOfLines = 0
        
        var oneCase: Case?
        
        if indexPath.section == 0 {
            oneCase = unViewedCases![indexPath.row]
        }
        else if indexPath.section == 1 {
            oneCase = viewedCases![indexPath.row]
        }
        cell.textLabel?.text = oneCase!.caseProcedureString()
        var attendingName = ""
        if let fullName = oneCase!.attendingObject?.fullName() {
            attendingName = fullName
        }
        cell.detailTextLabel?.text = "\(attendingName) on \(oneCase!.caseDateString())"
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let array = indexPath.section == 0 ? unViewedCases : viewedCases
        let theCase = array![indexPath.row]
        
        //move the case from unviewed to viewed and update remote data
        if indexPath.section == 0 {
            caseListDirty = true
            let caseToMove = array![indexPath.row]
            viewedCases?.append(caseToMove)
            unViewedCases?.removeAtIndex(array!.indexOf(caseToMove)!)
            let caseUpdater = CaseUpdater(theCase: caseToMove)
            caseUpdater.updateAfterResidentView()
        }
        
        self.performSegueWithIdentifier(completedCaseDetailSegue, sender: theCase)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if let unViewedCases = unViewedCases {
                if unViewedCases.count > 0 {
                    return "Cases to Review"
                }
            }
        }
        if section == 1 {
            if let viewedCases = viewedCases {
                if viewedCases.count > 0 {
                    return "Cases Already Reviewed"
                }
            }
        }
        return nil
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == completedCaseDetailSegue {
            let vc = segue.destinationViewController as? CompletedCaseDetailViewController
            vc?.theCase = sender as? Case
        }
    }
    

}
