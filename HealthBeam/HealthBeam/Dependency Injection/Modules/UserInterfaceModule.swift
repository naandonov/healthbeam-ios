//
//  UserInterfaceModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 21.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import Foundation
import Cleanse

struct UserInterfaceModule: Module {
    static func configure(binder: SingletonBinder) {
        binder.include(module: StoryboardsModule.self)
        binder.include(module: ViewControllersModule.self)
        binder.include(module: ViewsModule.self)
    }
}
