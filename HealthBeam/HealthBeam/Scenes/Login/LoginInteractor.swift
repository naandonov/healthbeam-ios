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
    var postAuthorizationHandler: PostAuthorizationHandler? { get set }
}

protocol PostAuthorizationHandler: class {
    func handleSuccessfullAuthorization(userProfile: UserProfile.Model)
}

weak var postAuthorizationHandler: PostAuthorizationHandler?


class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
    var presenter: LoginPresentationLogic?
    
    weak var postAuthorizationHandler: PostAuthorizationHandler?
    
    private var authorizationWorker: AuthorizationWorker
    private var coreDataHandler: CoreDataHandler
    private var networkingManager: NetworkingManager
    
    init(authorizationWorker: AuthorizationWorker,
         coreDataHandler: CoreDataHandler,
         networkingManager: NetworkingManager) {
        self.authorizationWorker = authorizationWorker
        self.coreDataHandler = coreDataHandler
        self.networkingManager = networkingManager
    }
    
    func login(request: Login.Interaction.Request) {
        let loginOperation = LoginOperation(request: request) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                guard let value = responseObject.value else {
                    strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: false, user: nil))
                    return
                }
                strongSelf.authorizationWorker.setAuthorizationToken(value.accessToken)
                strongSelf.getUserProfile()
                
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: false, user: nil))
            }
        }
        networkingManager.addNetwork(operation: loginOperation)
    }
    
    private func getUserProfile() {
        let getUserProfileOperation = GetUserProfileOperation { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                guard let value = responseObject.value else {
                    strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: false, user: nil))
                    return
                }
                strongSelf.storeUserProfile(value)
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: false, user: nil))
            }
        }
        networkingManager.addNetwork(operation: getUserProfileOperation)
        
    }
    
    private func storeUserProfile(_ userProfile: UserProfile.Model) {
        coreDataHandler.storeUserProfile(userProfile) { [weak self] success in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.processLogin(response: Login.Interaction.Response(isSuccessful: success, user: userProfile))
        }
    }
    
}
