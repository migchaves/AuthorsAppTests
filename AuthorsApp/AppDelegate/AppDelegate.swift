//
//  AppDelegate.swift
//  AuthorsApp
//
//  Created by Miguel on 17/01/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if CommandLine.arguments.contains("RunningTests") {
            // Set animations to false, to perfom the UI tests
            UIView.setAnimationsEnabled(false)
        }
        
        return true
    }
}
