//
//  MenuInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol MenuBusinessLogic {
    var presenter: MenuPresentationLogic? { get set }
    
    func performAuthorizationCheck(request: Menu.AuthorizationCheck.Request)
}

protocol MenuDataStore {
    
}

class MenuInteractor: MenuBusinessLogic, MenuDataStore {
    
    private let authorizationWorker: AuthorizationWorker
    var presenter: MenuPresentationLogic?
    
    init(authorizationWorker: AuthorizationWorker) {
        self.authorizationWorker = authorizationWorker
    }
    
    func performAuthorizationCheck(request: Menu.AuthorizationCheck.Request) {
        let authorizationGranted = authorizationWorker.checkForAuthorization()
        presenter?.handleAuthorization(response: Menu.AuthorizationCheck.Response(authorizationGranted: authorizationGranted))
    }
    
}
