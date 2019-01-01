//
//  AppDelegate.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 26.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit
import UserNotifications
import Cleanse
import SwiftyBeaver

//Global Logger
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var userNotificationCenter: UNUserNotificationCenter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        injectDependenciesGraph()
        applicationSetup()
        registerForPushNotifications()
        return true
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }

}

//MARK: - Utilities

extension AppDelegate {
    private func applicationSetup() {
        //Configuring the logger's output
        let console = ConsoleDestination()
        log.addDestination(console)
        //try? KeychainManager.deleteAuthorizationToken()
        userNotificationCenter?.requestAuthorization(options: [.sound, .alert], completionHandler: { _,_ in })
        window?.makeKeyAndVisible()
    }
    
    private func injectDependenciesGraph() {
        do {
            let propertyInjector: PropertyInjector<AppDelegate> = try ComponentFactory.of(ApplicationComponent.self).build(())
            propertyInjector.injectProperties(into: self)
        }
        catch {
            log.error(error.localizedDescription)
            fatalError("Unable to setup the dependency injection graph, reason: \(error.localizedDescription)")
        }
    }
}

//MARK: - Properties Injection

extension AppDelegate {
    func injectProperties(_ window: UIWindow, userNotificationCenter: UNUserNotificationCenter) {
        self.window = window
        self.userNotificationCenter = userNotificationCenter
    }
}


