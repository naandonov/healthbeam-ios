//
//  MenuRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol MenuRoutingLogic {
    var viewController: MenuViewController? { get set }
    
    func routeToAuthorization(withHandler handler: PostAuthorizationHandler?, animated: Bool)
}

protocol MenuDataPassing {
    var dataStore: MenuDataStore? {get set}
}

class MenuRouter:  MenuRoutingLogic, MenuDataPassing {
    
    weak var viewController: MenuViewController?
    var dataStore: MenuDataStore?
    
    private let loginViewControllerProvider: Provider<LoginViewController>
    
    func routeToAuthorization(withHandler handler: PostAuthorizationHandler?, animated: Bool) {
        if viewController?.presentedViewController != nil {
            return
        }
        let loginViewController = loginViewControllerProvider.get()
        loginViewController.router?.dataStore?.postAuthorizationHandler = handler
        viewController?.present(loginViewController, animated: animated, completion: nil)
    }
    
    init(loginViewControllerProvider: Provider<LoginViewController>) {
        self.loginViewControllerProvider = loginViewControllerProvider
    }
}
