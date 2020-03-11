//
//  AppDelegate.swift
//  CoreDataTemp
//
//  Created by Denis on 11.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: TaskListViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

