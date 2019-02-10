//
//  RoutersModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 26.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import Foundation
import Cleanse

class RoutersModule: Module {
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind(LoginRouterProtocol.self)
            .to(factory: LoginRouter.init)
        
        binder
            .bind(MenuRouterProtocol.self)
            .to(factory: MenuRouter.init)

        binder
            .bind(PatientsSearchRouterProtocol.self)
            .to(factory: PatientsSearchRouter.init)
        
        binder
            .bind(PatientDetailsRouterProtocol.self)
            .to(factory: PatientDetailsRouter.init)
        
        binder
            .bind(PatientModificationRouterProtocol.self)
            .to(factory: PatientModificationRouter.init)
        
        binder
            .bind(HealthRecordRouterProtocol.self)
            .to(factory: HealthRecordRouter.init)
        
        binder
            .bind(HealthRecordModificationRouterProtocol.self)
            .to(factory: HealthRecordModificationRouter.init)
        
        binder
            .bind(PatientTagsSearchRouterProtocol.self)
            .to(factory: PatientTagsSearchRouter.init)

    }
}
