//
//  ArchitectureModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 26.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import Foundation

import Foundation
import Cleanse

class ArchitectureModule: Module {
    static func configure(binder: SingletonBinder) {
        binder.include(module: InteractorsModule.self)
        binder.include(module: PresentersModule.self)
        binder.include(module: RoutersModule.self)
        binder.include(module: WorkersModule.self)
    }
}
