//
//  InteractorsModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 26.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import Foundation
import Cleanse

class InteractorsModule: Module {
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind(LoginInteractorProtocol.self)
            .to(factory: LoginInteractor.init)
        
        binder
            .bind(MenuInteractorProtocol.self)
            .to(factory: MenuInteractor.init)
        
        binder
            .bind(PatientsSearchInteractorProtocol.self)
            .to(factory: PatientsSearchInteractor.init)
        
        binder
            .bind(PatientDetailsInteractorProtocol.self)
            .to(factory: PatientDetailsInteractor.init)
        
        binder
            .bind(PatientModificationInteractorProtocol.self)
            .to(factory: PatientModificationInteractor.init)
    }
}
