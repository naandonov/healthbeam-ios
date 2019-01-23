//
//  UserEntity+Mapping.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 23.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import Foundation

extension UserEntity {
    
    func modelWithPremise(_ premise: Premise) -> UserProfile.Model? {
        var model: UserProfile.Model?
        if let fullName = fullName,
            let email = email,
            let designation = designation,
            let accountType = accountType {
            model = UserProfile.Model(id: Int(id),
                                      fullName: fullName,
                                      designation: designation,
                                      email: email,
                                      discoveryRegions: discoveryRegions ?? [],
                                      accountType: accountType,
                                      premise: premise)
        }
        
        return model
    }
    
    func assignFromModel(_ model: UserProfile.Model) {
        id = Int64(model.id)
        fullName = model.fullName
        email = model.email
        designation = model.designation
        accountType = model.accountType
        discoveryRegions = model.discoveryRegions
    }
    
}
