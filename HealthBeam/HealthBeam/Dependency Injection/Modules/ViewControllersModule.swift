//
//  ViewControllersModule.swift
//  Sesame
//
//  Created by Nikolay Andonov on 21.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import UIKit
import Cleanse


struct ViewControllersModule: Module {
    static func configure(binder: SingletonBinder) {
        
        binder
            .bind(ViewController.self)
            .to {  (storyboard: TaggedProvider<MainStoryboard>/*, injector: PropertyInjector<ExitPremiseViewController>*/) in
                let viewController: ViewController! =  storyboard.get().instantiateViewController()
//                injecotr.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(LoginViewController.self)
            .to {  (storyboard: TaggedProvider<AuthenticationStoryboard>, injector: PropertyInjector<LoginViewController>) in
                let viewController: LoginViewController! =  storyboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(MenuViewController.self)
            .to {  (storyboard: TaggedProvider<MenuStoryboard>, injector: PropertyInjector<MenuViewController>) in
                let viewController: MenuViewController! =  storyboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(PatientsSearchViewController.self)
            .to {  (storyboard: TaggedProvider<PatientsStoryboard>, injector: PropertyInjector<PatientsSearchViewController>) in
                let viewController: PatientsSearchViewController! =  storyboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(PatientDetailsViewController.self)
            .to {  (storyboard: TaggedProvider<PatientsStoryboard>, injector: PropertyInjector<PatientDetailsViewController>) in
                let viewController: PatientDetailsViewController! =  storyboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(PatientModificationViewController.self)
            .to {  (storyboard: TaggedProvider<PatientsStoryboard>, injector: PropertyInjector<PatientModificationViewController>) in
                let viewController: PatientModificationViewController! =  storyboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(HealthRecordViewController.self)
            .to {  (storyboard: TaggedProvider<HealthRecordsStoryboard>, injector: PropertyInjector<HealthRecordViewController>) in
                let viewController: HealthRecordViewController! =  storyboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(HealthRecordModificationViewController.self)
            .to {  (storyboard: TaggedProvider<HealthRecordsStoryboard>, injector: PropertyInjector<HealthRecordModificationViewController>) in
                let viewController: HealthRecordModificationViewController! =  storyboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bindPropertyInjectionOf(LoginViewController.self)
            .to(injector: LoginViewController.injectProperties)
        
        binder
            .bindPropertyInjectionOf(MenuViewController.self)
            .to(injector: MenuViewController.injectProperties)
        
        binder
            .bindPropertyInjectionOf(PatientsSearchViewController.self)
            .to(injector: PatientsSearchViewController.injectProperties)
        
        binder
            .bindPropertyInjectionOf(PatientDetailsViewController.self)
            .to(injector: PatientDetailsViewController.injectProperties)
        
        binder
            .bindPropertyInjectionOf(PatientModificationViewController.self)
            .to(injector: PatientModificationViewController.injectProperties)
        
        binder
            .bindPropertyInjectionOf(HealthRecordViewController.self)
            .to(injector: HealthRecordViewController.injectProperties)
        
        binder
            .bindPropertyInjectionOf(HealthRecordModificationViewController.self)
            .to(injector: HealthRecordModificationViewController.injectProperties)
    }
}
