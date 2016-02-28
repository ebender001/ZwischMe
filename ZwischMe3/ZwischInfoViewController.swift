//
//  ZwischInfoViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/27/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class ZwischInfoViewController: UIViewController {

    var zwisch: ZwischStage?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = zwisch!.zwischName
        webView.loadHTMLString(configureHtml(), baseURL: NSBundle.mainBundle().bundleURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureHtml() -> String {
        var htmlString = ""
        
        if let item = zwisch {
            let str = item.zwischInformation
            let array = str?.componentsSeparatedByString("|")
            if let array = array {
                htmlString = "<html><head><link rel='stylesheet' type='text/css' href='style.css'></head><body><ul>"
                for oneItem in array {
                    htmlString += "<li>\(oneItem)</li>"
                }
                htmlString += "</ul></body></html>"
            }
        }
        return htmlString
    }

}
