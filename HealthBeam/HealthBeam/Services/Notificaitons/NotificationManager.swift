//
//  NotificationsManager.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import UserNotifications

typealias TokenRequest = ((String) -> Void)

class NotificationManger: NSObject {
    
    private let userNotificationCenter: UNUserNotificationCenter
    private let sharedApplication: UIApplication
    
    
    private var tokenRequestHandlers: [TokenRequest] = []
    private var deviceTokenString: String?
    
    
    func requestNotifiationServices() {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in

        }
    }
    
    func requestDeviceToken(completitionHandler: @escaping TokenRequest) {
        UIApplication.shared.registerForRemoteNotifications()
        if let deviceTokenString = deviceTokenString{
            completitionHandler(deviceTokenString)
        }
        else {
            tokenRequestHandlers.append(completitionHandler)
        }
    }
    
    func setBadgeCount(_ count: Int) {
        sharedApplication.applicationIconBadgeNumber = count
    }
    
    
    
    init(userNotificationCenter: UNUserNotificationCenter, sharedApplication: UIApplication) {
        self.userNotificationCenter = userNotificationCenter
        self.sharedApplication = sharedApplication
        super.init()
        userNotificationCenter.delegate = self
    }
    
}

extension NotificationManger: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        for completitionHandler in tokenRequestHandlers {
            completitionHandler(token)
        }
        deviceTokenString = token
        tokenRequestHandlers = []
    }
}
