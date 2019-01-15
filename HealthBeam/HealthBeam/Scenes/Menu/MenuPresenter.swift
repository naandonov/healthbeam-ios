//
//  MenuPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol MenuPresentationLogic {
    var presenterOutput: MenuDisplayLogic? { get set }
    
    func handleAuthorization(response: Menu.AuthorizationCheck.Response)
    func handleUserProfileUpdate(response: Menu.UserProfileUpdate.Response)
    
}

class MenuPresenter: MenuPresentationLogic {
    
    weak var presenterOutput: MenuDisplayLogic?
    
    
    func handleAuthorization(response: Menu.AuthorizationCheck.Response) {
        let viewModel = Menu.AuthorizationCheck.ViewModel(authorizationGranted: response.authorizationGranted)
        presenterOutput?.didPerformAuthorizationCheck(viewModel: viewModel)
    }
    
    func handleUserProfileUpdate(response: Menu.UserProfileUpdate.Response) {
        presenterOutput?.didPerformProfileUpdate(viewModel: Menu.UserProfileUpdate.ViewModel(user: response.user))
    }

}
