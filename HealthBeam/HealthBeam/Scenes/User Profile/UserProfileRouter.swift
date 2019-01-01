//
//  UserProfileRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 1.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol UserProfileRoutingLogic {
    var viewController: UserProfileViewController? { get set }
}

protocol UserProfileDataPassing {
    var dataStore: UserProfileDataStore? {get set}
}

class UserProfileRouter:  UserProfileRoutingLogic, UserProfileDataPassing {
    
  weak var viewController: UserProfileViewController?
  var dataStore: UserProfileDataStore?
    
}
