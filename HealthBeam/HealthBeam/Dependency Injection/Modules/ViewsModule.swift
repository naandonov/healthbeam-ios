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
            .to { return LightLogoView.fromNib() }
        
        binder
            .bind(StartupLoadingView.self)
            .to { return StartupLoadingView.fromNib() }

        binder
            .bind(InformationCardView.self)
            .to { return InformationCardView.fromNib() }
  
        binder
            .bind(ScanningView.self)
            .to { return ScanningView.fromNib() }
        
        binder
            .bind(EmptyStateView.self)
            .to { return EmptyStateView.fromNib() }
    }
}
