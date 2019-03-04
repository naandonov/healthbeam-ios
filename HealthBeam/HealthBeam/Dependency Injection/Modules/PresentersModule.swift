//
//  PresentersModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 26.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import Foundation
import Cleanse

class PresentersModule: Module {
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind(LoginPresenterProtocol.self)
            .to(factory: LoginPresenter.init)
        
        binder
            .bind(MenuPresenterProtocol.self)
            .to(factory: MenuPresenter.init)
        
        binder
            .bind(PatientsSearchPresenterProtocol.self)
            .to(factory: PatientsSearchPresenter.init)
        
        binder
            .bind(PatientDetailsPresenterProtocol.self)
            .to(factory: PatientDetailsPresenter.init)
        
        binder
            .bind(PatientModificationPresenterProtocol.self)
            .to(factory: PatientModificationPresenter.init)
        
        binder
            .bind(HealthRecordPresenterProtocol.self)
            .to(factory: HealthRecordPresenter.init)
        
        binder
            .bind(HealthRecordModificationPresenterProtocol.self)
            .to(factory: HealthRecordModificationPresenter.init)
        
        binder
            .bind(PatientTagsSearchPresenterProtocol.self)
            .to(factory: PatientTagsSearchPresenter.init)
        
        binder
            .bind(LocatePatientsPresenterProtocol.self)
            .to(factory: LocatePatientsPresenter.init)
        
        binder
            .bind(AboutPresenterProtocol.self)
            .to(factory: AboutPresenter.init)
        
        binder
            .bind(WebContentPresenterProtocol.self)
            .to(factory: WebContentPresenter.init)
        
        binder
            .bind(PatientAlertsPresenterProtocol.self)
            .to(factory: PatientAlertsPresenter.init)

    }
}
