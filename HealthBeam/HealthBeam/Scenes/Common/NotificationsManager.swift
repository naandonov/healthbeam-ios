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
    private var tokenRequestHandlers: [TokenRequest] = []
    private var deviceTokenString: String?
    
    
    func requestNotifiationServices() {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            
        }
    }
    
    func requestDeviceToken(completitionHandler: @escaping TokenRequest) {
        if let deviceTokenString = deviceTokenString{
            completitionHandler(deviceTokenString)
        }
        else {
            tokenRequestHandlers.append(completitionHandler)
        }
    }
    
    init(userNotificationCenter: UNUserNotificationCenter) {
        self.userNotificationCenter = userNotificationCenter
        super.init()
        userNotificationCenter.delegate = self
    }
    
}

extension NotificationManger: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
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
