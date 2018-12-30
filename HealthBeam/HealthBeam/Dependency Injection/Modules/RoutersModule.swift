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

    }
}
