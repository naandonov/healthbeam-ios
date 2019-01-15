//
//  ViewsModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 26.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import UIKit
import Cleanse

struct ViewsModule: Module {
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind(LightLogoView.self)
            .to(value: LightLogoView.fromNib())
        
        binder
            .bind(StartupLoadingView.self)
            .to(value: StartupLoadingView.fromNib())
    }
}
