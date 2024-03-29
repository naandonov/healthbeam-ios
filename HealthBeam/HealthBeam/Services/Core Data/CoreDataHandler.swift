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
typealias UserFetchCompletion = (UserProfile.Model?) -> ()


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
                let userEntity = try strongSelf.createOrUpdateUserEntity(for: userProfile, context: context)
                let premiseEntity = try strongSelf.createOrFetchPremise(for: userProfile.premise, context: context)
                userEntity.premise = premiseEntity
                premiseEntity.addToUsers(userEntity)
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
    
    func getUserProfile(completition: UserFetchCompletion) {
        let context = coreDataStack.mainContext
        context.performAndWait {
            let usersFetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            let users = try? context.fetch(usersFetchRequest)
            
            if let existingUser = users?.first,
                let premise = existingUser.premise,
                let premiseModel = premise.model(),
                let userModel = existingUser.modelWithPremise(premiseModel) {
                    completition(userModel)
                return
            }
            completition(nil)
        }
    }
}

extension CoreDataHandler {
    
    private func createOrUpdateUserEntity(for userProfile: UserProfile.Model, context: NSManagedObjectContext) throws -> UserEntity {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        //        fetchRequest.predicate = NSPredicate(format: "email = %@", userProfile.email)
        
        let userEntity: UserEntity
        if let existingUser = try context.fetch(fetchRequest).first {
            userEntity = existingUser
        } else {
            userEntity = NSEntityDescription.insertNewObject(forEntityName: UserEntity.entityName, into: context) as! UserEntity
        }
        
        userEntity.assignFromModel(userProfile)
        
        return userEntity
    }
    
    private func createOrFetchPremise(for premiseModel: Premise, context: NSManagedObjectContext) throws -> PremiseEntity {
        let fetchRequest: NSFetchRequest<PremiseEntity> = PremiseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %lld", Int64(premiseModel.id))
        
        if let existingPremise = try context.fetch(fetchRequest).first {
            return existingPremise
        } else {
            let premiseEntity = NSEntityDescription.insertNewObject(forEntityName: PremiseEntity.entityName, into: context) as! PremiseEntity
            premiseEntity.assignFromModel(premiseModel)
            return premiseEntity
        }
    }
}

