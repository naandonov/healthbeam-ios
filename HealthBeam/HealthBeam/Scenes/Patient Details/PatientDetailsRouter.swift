//
//  PatientDetailsRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientDetailsRoutingLogic {
    var viewController: PatientDetailsViewController? { get set }
}

protocol PatientDetailsDataPassing {
    var dataStore: PatientDetailsDataStore? {get set}
}

class PatientDetailsRouter:  PatientDetailsRoutingLogic, PatientDetailsDataPassing {
    
  weak var viewController: PatientDetailsViewController?
  var dataStore: PatientDetailsDataStore?
    
}
