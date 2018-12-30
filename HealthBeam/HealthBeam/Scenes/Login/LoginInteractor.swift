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
}

protocol LoginDataStore {

}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
  var presenter: LoginPresentationLogic?
    
}
