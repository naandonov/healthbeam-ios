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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var userNotificationCenter: UNUserNotificationCenter?
    private var notificationManager: NotificationManger?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        injectDependenciesGraph()
        applicationSetup()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationManager?.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

}

//MARK: - Utilities

extension AppDelegate {
    private func applicationSetup() {
        //Configuring the logger's output
        let console = ConsoleDestination()
        log.addDestination(console)
//        try? KeychainManager.deleteAuthorizationToken()
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
    func injectProperties(_ window: UIWindow, userNotificationCenter: UNUserNotificationCenter, notificationManager: NotificationManger, authorizationWorker: AuthorizationWorker) {
        self.window = window
        self.userNotificationCenter = userNotificationCenter
        self.notificationManager = notificationManager
        
        //Manual Injection
        Injector.authorizationWorker = authorizationWorker
    }
}


