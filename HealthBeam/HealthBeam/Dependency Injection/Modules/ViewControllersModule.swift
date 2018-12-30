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
            .bindPropertyInjectionOf(LoginViewController.self)
            .to(injector: LoginViewController.injectProperties)
    
        
    }
}
