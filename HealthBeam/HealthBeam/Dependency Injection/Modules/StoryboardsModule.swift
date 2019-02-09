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

struct AuthenticationStoryboard: Tag {
    typealias Element = UIStoryboard
}

struct MenuStoryboard: Tag {
    typealias Element = UIStoryboard
}

struct PatientsStoryboard: Tag {
    typealias Element = UIStoryboard
}

struct HealthRecordsStoryboard: Tag {
    typealias Element = UIStoryboard
}

struct StoryboardsModule: Module {
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind()
            .tagged(with: MainStoryboard.self)
            .to(value: UIStoryboard.main)
        
        binder
            .bind()
            .tagged(with: AuthenticationStoryboard.self)
            .to(value: UIStoryboard.authentication)
        
        binder
            .bind()
            .tagged(with: MenuStoryboard.self)
            .to(value: UIStoryboard.menu)
        
        binder
            .bind()
            .tagged(with: PatientsStoryboard.self)
            .to(value: UIStoryboard.patients)
        
        binder
            .bind()
            .tagged(with: HealthRecordsStoryboard.self)
            .to(value: UIStoryboard.healthRecords)
    }
}
