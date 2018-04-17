//
//  AppDelegate.swift
//  PhotoHub
//
//  Created by Kelly Jewkes on 3/5/18.
//  Copyright © 2018 LightWing. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserController.sharedController.fetchCurrentUser()
        // request notification permissions request
        let unc = UNUserNotificationCenter.current()
        unc.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
        if let error = error {
            NSLog("Error requesting authorization for notifications: \(error)")
            return
        }
    }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        
        return true
    }
        
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       // PhotoController.sharedController.fetch

        completionHandler(UIBackgroundFetchResult.newData)
    }

}




