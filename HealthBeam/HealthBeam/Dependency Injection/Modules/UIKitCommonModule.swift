//
//  UIKitCommonModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 21.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import UIKit
import Cleanse

struct UIKitCommonModule: Module {
    
    static func configure(binder: UnscopedBinder) {
        
        binder
            .bind(UIScreen.self)
            .to { UIScreen.main }
        
        binder
            .bind(UIApplication.self)
            .to { UIApplication.shared }
        
        binder
            .bind(UIWindow.self)
            .to { (mainScreen: UIScreen, rootViewController: ViewController) in
                let window = UIWindow(frame: mainScreen.bounds)
                window.rootViewController = rootViewController
                return window
        }
    }
}

