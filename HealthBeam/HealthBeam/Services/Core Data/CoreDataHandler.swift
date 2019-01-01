//
//  CoreDataHandler.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation
import CoreData

typealias CoreDataCompletion = (Bool) -> ()

class CoreDataHandler {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func storeUserProfile(_ userProfile: UserProfile.Model, completion: CoreDataCompletion?) {
        let context = coreDataStack.mainContext
        context.perform { [weak self] in
            guard let strongSelf = self else {
                if let completion = completion {
                    completion(false)
                }
                return
            }
            do {
                _ = try strongSelf.createOrUpdateUserEntity(for: userProfile, context: context)
                try context.save()
                if let completion = completion {
                    completion(true)
                }
            }
            catch {
                log.error("Core Data has encountered an error, reason: \(error.localizedDescription)")
                if let completion = completion {
                    completion(false)
                }
            }
        }
    }
}

extension CoreDataHandler {
    
    private func createOrUpdateUserEntity(for userProfile: UserProfile.Model, context: NSManagedObjectContext) throws -> UserEntity {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email = %@", userProfile.email)
        
        let userEntity: UserEntity
        if let existingUser = try context.fetch(fetchRequest).first {
            userEntity = existingUser
        }
        else {
            userEntity = NSEntityDescription.insertNewObject(forEntityName: UserEntity.entityName, into: context) as! UserEntity
        }
        
        userEntity.id = Int64(userProfile.id)
        userEntity.fullName = userProfile.fullName
        userEntity.email = userProfile.email
        userEntity.designation = userProfile.designation
        userEntity.accountType = userProfile.accountType
        userEntity.discoveryRegions = userProfile.discoveryRegions
        
        return userEntity
    }
}
