//
//  LoginRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.12.18.
//  Copyright (c) 2018 nikolay.andonov. All rights reserved.
//

import UIKit

protocol LoginRoutingLogic {
    var viewController: LoginViewController? { get set }
    
    func dismiss(forAuthenticated user: UserProfile.Model)
}

protocol LoginDataPassing {
    var dataStore: LoginDataStore? {get set}
}

class LoginRouter: LoginRoutingLogic, LoginDataPassing {
    
  weak var viewController: LoginViewController?
  var dataStore: LoginDataStore?
    
    func dismiss(forAuthenticated user: UserProfile.Model) {
        viewController?.dismiss(animated: true) { [weak self] in
            self?.dataStore?.postAuthorizationHandler?.handleSuccessfullAuthorization(userProfile: user)
        }
    }
}
