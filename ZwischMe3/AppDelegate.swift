//
//  AppDelegate.swift
//  ZwischMe3
//
//  Created by Edward Bender on 2/26/16.
//  Copyright © 2016 Edward Bender. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let APP_ID = "F676E52F-E379-E9D6-FF52-1588C9CE6600"
    let SECRET_KEY = "18D2DA99-D5F8-AA31-FF14-80B2C5DEFE00"
    let VERSION_NUMBER = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    var attendingPendingCases: Int = 0

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        backendless.initApp(APP_ID, secret: SECRET_KEY, version: VERSION_NUMBER)
        backendless.userService.setStayLoggedIn(true)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if let currentUser = backendless.userService.currentUser {
            if let attendingObject = currentUser.getProperty("allowedUser") {
                let backgroundFetcher = BackgroundAttendingCaseFetcher(attending: attendingObject as! AllowedUsers, handler: completionHandler)
                backgroundFetcher.startFetch()
            }
            
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        backendless.messaging.registerDeviceToken(deviceToken)
        //backendless.messaging.registerDeviceWithTokenData(deviceToken)
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        application.applicationIconBadgeNumber = attendingPendingCases
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        attendingPendingCases = application.applicationIconBadgeNumber
    }

    func applicationWillTerminate(application: UIApplication) {
        application.applicationIconBadgeNumber = attendingPendingCases
    }


}

