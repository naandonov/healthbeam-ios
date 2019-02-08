//
//  PatientModificationRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol PatientModificationRoutingLogic {
    var viewController: PatientModificationViewController? { get set }
    
    func routeToPreviousScreen()
}

protocol PatientModificationDataPassing {
    var dataStore: PatientModificationDataStore? {get set}
}

class PatientModificationRouter:  PatientModificationRoutingLogic, PatientModificationDataPassing {
    
  weak var viewController: PatientModificationViewController?
  var dataStore: PatientModificationDataStore?
    
    func routeToPreviousScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    
}
