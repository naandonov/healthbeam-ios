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

protocol NotificationMangerDelegate: class {
    func didReceivePendingAlertNotification(alertId: String)
    func didSetBadgeCount(_ badgeCount: Int)
}

class NotificationManger: NSObject {
    
    private let userNotificationCenter: UNUserNotificationCenter
    private let sharedApplication: UIApplication
    
    private var tokenRequestHandlers: [TokenRequest] = []
    private var deviceTokenString: String?
    
    private(set) var pendingNotificationAlertId: String?
    
    weak var delegate: NotificationMangerDelegate?
    
    func requestNotifiationServices() {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            
        }
    }
    
    func clearPendingNotificationAlertId() {
        pendingNotificationAlertId = nil
    }
    
    func didReceiveRemoteNotificaitonWith(userInfo: [AnyHashable : Any]) {
        guard let extra = userInfo["extra"] as? [String: String],
            let aps = userInfo["aps"] as? [String: Any],
            let alertId = extra["alertId"],
            let status = extra["alertStatus"] else {
                return
        }
        
        if let badgeCount = aps["badge"] as? Int {
            setBadgeCount(badgeCount)
        }
        
        if status == "pending" {
            pendingNotificationAlertId = alertId
            if let delegate = delegate {
                delegate.didReceivePendingAlertNotification(alertId: alertId)
                pendingNotificationAlertId = nil
            }
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
        if sharedApplication.applicationIconBadgeNumber != count {
            sharedApplication.applicationIconBadgeNumber = count
            delegate?.didSetBadgeCount(count)
        }
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
