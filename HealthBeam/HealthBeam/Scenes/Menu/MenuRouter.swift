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
    func routeToPatientsSearch()
}

protocol MenuDataPassing {
    var dataStore: MenuDataStore? {get set}
}

class MenuRouter:  MenuRoutingLogic, MenuDataPassing {
    
    weak var viewController: MenuViewController?
    var dataStore: MenuDataStore?
    
    private let loginViewControllerProvider: Provider<LoginViewController>
    private let patientsSearchViewControllerProvider: Provider<PatientsSearchViewController>
    
    func routeToAuthorization(withHandler handler: PostAuthorizationHandler?, animated: Bool) {
        if viewController?.presentedViewController != nil {
            return
        }
        let loginViewController = loginViewControllerProvider.get()
        loginViewController.router?.dataStore?.postAuthorizationHandler = handler
        viewController?.present(loginViewController, animated: animated, completion: nil)
    }
    
    func routeToPatientsSearch() {
        guard viewController?.navigationController?.viewControllers.count == 1 else {
            return
        }
        let patientsSearchViewController = patientsSearchViewControllerProvider.get()
        viewController?.navigationController?.pushViewController(patientsSearchViewController, animated: true)
    }
    
    init(loginViewControllerProvider: Provider<LoginViewController>,
         patientsSearchViewControllerProvider: Provider<PatientsSearchViewController>) {
        self.loginViewControllerProvider = loginViewControllerProvider
        self.patientsSearchViewControllerProvider = patientsSearchViewControllerProvider
    }
}
