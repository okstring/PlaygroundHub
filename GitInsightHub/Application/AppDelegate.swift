//
//  AppDelegate.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        CoreDataStack.shared.saveContext()
    }
}

