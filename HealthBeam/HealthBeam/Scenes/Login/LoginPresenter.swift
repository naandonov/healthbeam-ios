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
}

class LoginPresenter: LoginPresentationLogic {
    
  weak var presenterOutput: LoginDisplayLogic?
    
}
