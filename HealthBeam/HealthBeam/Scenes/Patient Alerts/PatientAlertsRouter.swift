//
//  PatientAlertsRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.03.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientAlertsRoutingLogic {
    var viewController: PatientAlertsViewController? { get set }
}

protocol PatientAlertsDataPassing {
    var dataStore: PatientAlertsDataStore? {get set}
}

class PatientAlertsRouter:  PatientAlertsRoutingLogic, PatientAlertsDataPassing {
    
  weak var viewController: PatientAlertsViewController?
  var dataStore: PatientAlertsDataStore?
    
}
