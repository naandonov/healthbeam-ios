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
            .to {  (mainStoryboard: TaggedProvider<MainStoryboard>/*, injector: PropertyInjector<ExitPremiseViewController>*/) in
                let viewController: ViewController! =  mainStoryboard.get().instantiateViewController()
//                injecotr.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(LoginViewController.self)
            .to {  (authenticationStoryboard: TaggedProvider<AuthenticationStoryboard>, injector: PropertyInjector<LoginViewController>) in
                let viewController: LoginViewController! =  authenticationStoryboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(MenuViewController.self)
            .to {  (menuStoryboard: TaggedProvider<MenuStoryboard>, injector: PropertyInjector<MenuViewController>) in
                let viewController: MenuViewController! =  menuStoryboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(PatientsSearchViewController.self)
            .to {  (patientsStoryboard: TaggedProvider<PatientsStoryboard>, injector: PropertyInjector<PatientsSearchViewController>) in
                let viewController: PatientsSearchViewController! =  patientsStoryboard.get().instantiateViewController()
                injector.injectProperties(into: viewController)
                return viewController
        }
        
        binder
            .bind(PatientDetailsViewController.self)
            .to {  (patientsStoryboard: TaggedProvider<PatientsStoryboard>, injector: PropertyInjector<PatientDetailsViewController>) in
                let viewController: PatientDetailsViewController! =  patientsStoryboard.get().instantiateViewController()
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
    }
}
