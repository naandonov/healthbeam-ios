//
//  TagsLocatingInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 10.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

class TagsLocatingInteractor {
    
    private let coreDataHandler: CoreDataHandler
    private let notificationCenter: NotificationCenter
    private let beaconsManager: BeaconsManager
    
    required init(coreDataHandler: CoreDataHandler, notificationCenter: NotificationCenter, beaconsManager: BeaconsManager) {
        self.coreDataHandler = coreDataHandler
        self.notificationCenter = notificationCenter
        self.beaconsManager = beaconsManager
    }
}
