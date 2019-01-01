//
//  LoginInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.12.18.
//  Copyright (c) 2018 nikolay.andonov. All rights reserved.
//

import UIKit

protocol LoginBusinessLogic {
    var presenter: LoginPresentationLogic? { get set }
    
    func login(request: Login.Interaction.Request)
}

protocol LoginDataStore {
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
    var presenter: LoginPresentationLogic?
    
    private var authorizationWorker: AuthorizationWorker
    private var coreDataHandler: CoreDataHandler
    
    init(authorizationWorker: AuthorizationWorker, coreDataHandler: CoreDataHandler) {
        self.authorizationWorker = authorizationWorker
        self.coreDataHandler = coreDataHandler
    }
    
    func login(request: Login.Interaction.Request) {
        let loginOperation = LoginOperation(request: request) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                guard let value = responseObject.value else {
                    strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: false))
                    return
                }
                strongSelf.authorizationWorker.setAuthorizationToken(value.accessToken)
                strongSelf.getUserProfile()
                
            case let .failure(responseObject):
                log.error(responseObject.localizedDescription)
                strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: false))
            }
        }
        NetworkingManager.shared.addNetwork(operation: loginOperation)
    }
    
    private func getUserProfile() {
        let getUserProfileOperation = GetUserProfileOperation { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                guard let value = responseObject.value else {
                    strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: false))
                    return
                }
                strongSelf.storeUserProfile(value)
            case let .failure(responseObject):
                log.error(responseObject.localizedDescription)
                strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: false))
            }
        }
        NetworkingManager.shared.addNetwork(operation: getUserProfileOperation)
        
    }
    
    private func storeUserProfile(_ userProfile: UserProfile.Model) {
        coreDataHandler.storeUserProfile(userProfile) { [weak self] success in
            self?.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: success))
        }
    }
    
}
