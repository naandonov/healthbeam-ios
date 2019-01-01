//
//  UserProfilePresenter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol UserProfilePresentationLogic {
    var presenterOutput: UserProfileDisplayLogic? { get set }
}

class UserProfilePresenter: UserProfilePresentationLogic {
    
  weak var presenterOutput: UserProfileDisplayLogic?
    
}
