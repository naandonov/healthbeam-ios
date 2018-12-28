//
//  WorkersModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 26.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import UIKit
import Cleanse

class WorkersModule: Module {
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind(AuthorizationWorker.self)
            .to(factory: AuthorizationWorker.init)
        
        binder
            .bind(UINotificationFeedbackGenerator.self)
            .to(factory: UINotificationFeedbackGenerator.init)
        
        
    }
}
