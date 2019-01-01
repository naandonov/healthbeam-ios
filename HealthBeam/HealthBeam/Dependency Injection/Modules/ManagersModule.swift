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
            .bind(CoreDataHandler.self)
            .sharedInScope()
            .to(factory: CoreDataHandler.init)
        
        binder
            .bind(CoreDataStack.self)
            .to(factory: CoreDataManager.init)
        
        binder
            .bind(NotificationCenter.self)
            .to(value: NotificationCenter.default)
        
        binder
            .bind(UNUserNotificationCenter.self)
            .to(value: UNUserNotificationCenter.current())
        
        binder
            .bind(AuthorizationWorker.self)
            .sharedInScope()
            .to(factory: AuthorizationManager.init)
    }
}
