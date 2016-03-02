//
//  AttendingZwischInfoViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/29/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class AttendingZwischInfoViewController: UIViewController, ZwischFetcherProtocol {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Zwisch Info"
        EZLoadingActivity.show("Fetching...", disableUI: true)
        let zwischFetcher = ZwischFetcher()
        zwischFetcher.delegate = self
        zwischFetcher.startFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureHtml(objects: [ZwischStage]) {
        var str = "<html><head><link rel='stylesheet' type='text/css' href='style.css'></head><body>"
        for oneObject in objects {
            let header = oneObject.zwischName!
            str += "<h2>\(header)</h2><ul>"
            let info = oneObject.zwischInformation!
            let array = info.componentsSeparatedByString("|")
            for oneInfo in array {
                str += "<li>\(oneInfo)</li>"
            }
            str += "</ul>"
        }
        
        str += "</body></html>"
        self.webView.loadHTMLString(str, baseURL: NSBundle.mainBundle().resourceURL)
        self.webView.scrollView.flashScrollIndicators()
    }

    //MARK: - DELEGATE METHODS
    func didFetchZwisch(zwisch: [ZwischStage]) {
        EZLoadingActivity.hide()
        configureHtml(zwisch)
    }
    func failedToFetchZwisch(reason: String) {
        EZLoadingActivity.hide()
        SJNotificationViewController(parentView: self.navigationController?.view, title: "Could not fetch Zwisch info.", level: SJNotificationLevelError, position: SJNotificationPositionBottom, spinner: false).showFor(2)
    }

}
