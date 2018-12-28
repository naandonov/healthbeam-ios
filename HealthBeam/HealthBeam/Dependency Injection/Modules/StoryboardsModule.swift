//
//  StoryboardsModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 21.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import UIKit
import Cleanse

struct MainStoryboard: Tag {
    typealias Element = UIStoryboard
}

struct PasscodeStoryboard: Tag {
    typealias Element = UIStoryboard
}

struct StoryboardsModule: Module {
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind()
            .tagged(with: MainStoryboard.self)
            .to(value: UIStoryboard(name: "Main", bundle: nil))
        
    }
}
