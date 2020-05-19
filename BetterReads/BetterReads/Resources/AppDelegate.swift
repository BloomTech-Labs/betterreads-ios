//
//  AppDelegate.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/16/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBarItem.appearance()
        .setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Regular", size: 11)!],
                                for: UIControl.State.normal)
        return true
    }
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
