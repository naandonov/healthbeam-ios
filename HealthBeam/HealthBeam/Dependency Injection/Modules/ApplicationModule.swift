//
//  ApplicationModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 21.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import Foundation
import Cleanse

struct ApplicationModule: Module {
    static func configure(binder: SingletonBinder) {
        binder.include(module: ManagersModule.self)
        binder.include(module: UserInterfaceModule.self)
        binder.include(module: ArchitectureModule.self)
    }
}
