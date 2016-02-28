//
//  ZwischTableViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class ZwischTableViewController: UITableViewController {
    var zwischArray: [ZwischStage]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Zwisch"
        navigationItem.hidesBackButton = true
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
        if let zwischArray = zwischArray {
            return zwischArray.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ZwischCell, forIndexPath: indexPath)

        cell.accessoryType = .DetailButton
        cell.textLabel?.textColor = greenColor
        
        let z = zwischArray![indexPath.row]
        cell.textLabel?.text = z.zwischName

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = tableView.frame.size.height - (navigationController?.navigationBar.frame.size.height)! - UIApplication.sharedApplication().statusBarFrame.size.height
        let numberComponents = zwischArray!.count
        return height / CGFloat(numberComponents)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let stage = zwischArray![indexPath.row]
        Case.sharedInstance.residentZwischStage = stage.zwischName!
        delay(0.2) { () -> () in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let zwischStage = zwischArray![indexPath.row]
        performSegueWithIdentifier(zwischInfoSegue, sender: zwischStage)
    }
    
    //MARK: - NAVIGATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == zwischInfoSegue {
            let vc = segue.destinationViewController as? ZwischInfoViewController
            vc?.zwisch = sender as? ZwischStage
        }
    }
    
}
