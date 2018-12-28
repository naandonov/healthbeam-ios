//
//  ApplicationComponent.swift
//  Sesame
//
//  Created by Nikolay Andonov on 21.11.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import Foundation
import Cleanse

public struct Singleton : Cleanse.Scope {
}

public typealias SingletonBinder = Binder<Singleton>

class ApplicationComponent: RootComponent {
    typealias Root = PropertyInjector<AppDelegate>

    static func configure(binder: SingletonBinder) {
        binder.include(module: ApplicationModule.self)
        binder.include(module: UIKitCommonModule.self)
    }
    
    static func configureRoot(binder bind: ReceiptBinder<PropertyInjector<AppDelegate>>) -> BindingReceipt<PropertyInjector<AppDelegate>> {
        return bind.propertyInjector(configuredWith: { return $0.to(injector: AppDelegate.injectProperties) })
    }
}
