//
//  LoginPresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.12.18.
//  Copyright (c) 2018 nikolay.andonov. All rights reserved.
//

import UIKit

protocol LoginPresentationLogic {
    var presenterOutput: LoginDisplayLogic? { get set }
    
    func processLogin(response: Login.Interaction.Response)
}

class LoginPresenter: LoginPresentationLogic {
    
    weak var presenterOutput: LoginDisplayLogic?
    
    func processLogin(response: Login.Interaction.Response) {
        let errorMessage = response.isSuccessful ? nil : "The provided credentials are either invalid or you are experiencing network conectivity issues".localized()
        presenterOutput?.displayLoginResult(viewModel: Login.Interaction.ViewModel(isSuccessful: response.isSuccessful, user: response.user, errorMessage: errorMessage))
    }
    
    
}
