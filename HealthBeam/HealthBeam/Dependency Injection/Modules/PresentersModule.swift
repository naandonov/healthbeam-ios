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

    }
}
