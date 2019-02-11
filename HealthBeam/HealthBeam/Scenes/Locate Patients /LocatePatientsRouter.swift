//
//  LocatePatientsRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 11.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol LocatePatientsRoutingLogic {
    var viewController: LocatePatientsViewController? { get set }
}

protocol LocatePatientsDataPassing {
    var dataStore: LocatePatientsDataStore? {get set}
}

class LocatePatientsRouter:  LocatePatientsRoutingLogic, LocatePatientsDataPassing {
    
  weak var viewController: LocatePatientsViewController?
  var dataStore: LocatePatientsDataStore?
    
}
