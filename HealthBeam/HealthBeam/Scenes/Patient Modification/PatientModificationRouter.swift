//
//  PatientModificationRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol PatientModificationRoutingLogic {
    var viewController: PatientModificationViewController? { get set }
    
    func routeToPreviousScreen()
    func routeToPatientDetails(witAttributes attributes: PatientAttributes)
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

    func routeToPatientDetails(witAttributes attributes: PatientAttributes) {
        if let patientDetailsViewController = dataStore?.patientDetailsViewControllerProvider?.get() {
            patientDetailsViewController.router?.dataStore?.patient = dataStore?.patient
            patientDetailsViewController.router?.dataStore?.modificationDelegate = dataStore?.modificationDelegate
            patientDetailsViewController.router?.dataStore?.patientAttributes = attributes
            viewController?.navigationController?.pushViewController(patientDetailsViewController, animated: true)
        }
    }
}
