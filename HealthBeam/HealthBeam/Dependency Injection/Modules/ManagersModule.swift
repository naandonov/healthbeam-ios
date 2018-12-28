//
//  ManagersModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 21.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import Foundation
import Cleanse
import UserNotifications

struct ManagersModule: Module {
    
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind(BeaconsManager.self)
            .sharedInScope()
            .to(factory: BeaconsManager.init)
        
        binder
            .bind(NetworkingManager.self)
            .sharedInScope()
            .to(factory: NetworkingManager.init)
        
        binder
            .bind(NotificationCenter.self)
            .to { NotificationCenter.default }
        
        binder
            .bind(UNUserNotificationCenter.self)
            .to { UNUserNotificationCenter.current() }
    }
}
