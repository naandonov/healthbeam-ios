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
import Firebase

//Global Logger
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var userNotificationCenter: UNUserNotificationCenter?
    private var notificationManager: NotificationManger?
    private var beaconsManager: BeaconsManager?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        injectDependenciesGraph()
        applicationSetup()
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationManager?.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        notificationManager?.didReceiveRemoteNotificaitonWith(userInfo: userInfo)
        completionHandler(.noData)
    }

}

//MARK: - Utilities

extension AppDelegate {
    private func applicationSetup() {
        //Configuring the logger's output
        let console = ConsoleDestination()
        log.addDestination(console)
//        try? KeychainManager.deleteAuthorizationToken()
        userNotificationCenter?.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { _,_ in })
        beaconsManager?.handleLocationServiceAuthorization()
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
    func injectProperties(_ window: UIWindow,
                          userNotificationCenter: UNUserNotificationCenter,
                          notificationManager: NotificationManger,
                          authorizationWorker: AuthorizationWorker,
                          beaconsManager: BeaconsManager) {
        self.window = window
        self.userNotificationCenter = userNotificationCenter
        self.notificationManager = notificationManager
        self.beaconsManager = beaconsManager
        
        //Manual Injection
        Injector.authorizationWorker = authorizationWorker
    }
}


