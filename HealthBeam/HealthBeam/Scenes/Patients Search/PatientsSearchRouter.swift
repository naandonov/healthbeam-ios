//
//  PatientsSearchRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientsSearchRoutingLogic {
    var viewController: PatientsSearchViewController? { get set }
}

protocol PatientsSearchDataPassing {
    var dataStore: PatientsSearchDataStore? {get set}
}

class PatientsSearchRouter:  PatientsSearchRoutingLogic, PatientsSearchDataPassing {
    
  weak var viewController: PatientsSearchViewController?
  var dataStore: PatientsSearchDataStore?
    
}
