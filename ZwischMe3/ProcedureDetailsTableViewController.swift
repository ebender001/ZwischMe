//
//  ProcedureDetailsTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class ProcedureDetailsTableViewController: UITableViewController, RedoProtocol {
    var procedureDetailsArray: [ProcedureDetails]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Procedure"
        
        let sd = NSSortDescriptor(key: "order", ascending: true)
        procedureDetailsArray = (procedureDetailsArray! as NSArray).sortedArrayUsingDescriptors([sd]) as? Array
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
        return procedureDetailsArray!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ProcedureDetailCell, forIndexPath: indexPath)

        cell.textLabel?.textColor = greenColor
        let procedureDetail = procedureDetailsArray![indexPath.row]
        cell.textLabel?.text = procedureDetail.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let procedureDetail = procedureDetailsArray![indexPath.row]
        Case.sharedInstance.procedureDetail = procedureDetail.name!
        self.performSegueWithIdentifier(redoSegue, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == redoSegue {
            let vc = segue.destinationViewController as? RedoViewController
            vc?.delegate = self
        }
    }
    
    //MARK: - REDO PROTOCOL METHOD
    func didDismiss(controller: RedoViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        delay(0.2) { () -> () in
            for vc: UIViewController in (self.navigationController?.viewControllers)! {
                if vc.isKindOfClass(NewCaseTableViewController) {
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }

}
