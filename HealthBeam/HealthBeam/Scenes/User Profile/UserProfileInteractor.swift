//
//  UserProfileInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol UserProfileBusinessLogic {
    var presenter: UserProfilePresentationLogic? { get set }
}

protocol UserProfileDataStore {

}

class UserProfileInteractor: UserProfileBusinessLogic, UserProfileDataStore {
    
  var presenter: UserProfilePresentationLogic?
    
}
