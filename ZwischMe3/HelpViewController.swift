//
//  HelpViewController.swift
//  ZwischMe3
//
//  Created by Edward Bender on 3/5/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        navBar.tintColor = lightBlueColor
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: orangeColor]

        EZLoadingActivity.show("Loading...", disableUI: false)
        let url = NSURL(string: "https://api.backendless.com/F676E52F-E379-E9D6-FF52-1588C9CE6600/v1/files/web/help.html")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissHelp(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: - DELEGATE METHODS
    func webViewDidFinishLoad(webView: UIWebView) {
        EZLoadingActivity.hide()
    }

}
