//
//  CoreDataManager.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStack {
    var mainContext: NSManagedObjectContext { get set}
    var privateContext: NSManagedObjectContext { get set}
}

class CoreDataManager: CoreDataStack {
    
    private var notificationCenter: NotificationCenter
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HealthBeamModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error))")
            }
        })
        log.debug(container.persistentStoreDescriptions)
        return container
    }()
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        notificationCenter.addObserver(self, selector: #selector(mainManagedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        return context
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        notificationCenter.addObserver(self, selector: #selector(privateManagedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        return context
    }()
}

//MARK:- Notification Events Handling

extension CoreDataManager {
    
    @objc private func mainManagedObjectContextDidSave(notification: Notification) {
        privateContext.mergeChanges(fromContextDidSave: notification)
    }
    
    @objc private func privateManagedObjectContextDidSave(notification: Notification) {
        mainContext.mergeChanges(fromContextDidSave: notification)
    }
}
