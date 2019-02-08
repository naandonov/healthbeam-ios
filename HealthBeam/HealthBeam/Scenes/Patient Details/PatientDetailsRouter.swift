//
//  PatientDetailsRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol PatientDetailsRoutingLogic {
    var viewController: PatientDetailsViewController? { get set }
    
    func routeToUpdatePatientScreen(for patient: Patient)
    
}

protocol PatientDetailsDataPassing {
    var dataStore: PatientDetailsDataStore? {get set}
}

class PatientDetailsRouter:  PatientDetailsRoutingLogic, PatientDetailsDataPassing {
    
  weak var viewController: PatientDetailsViewController?
  var dataStore: PatientDetailsDataStore?
    
    private let patientModificationViewControllerProvider: Provider<PatientModificationViewController>
    
    func routeToUpdatePatientScreen(for patient: Patient) {
        let patientModificationViewController = patientModificationViewControllerProvider.get()
        if let patientsSearchViewController = viewController?.navigationController?.viewControllers.filter({ $0 is PatientsSearchViewController }).first as? PatientsSearchViewController {
            patientModificationViewController.modificationDelegate = patientsSearchViewController
        }
        patientModificationViewController.attributesUpdateHandler = viewController
        patientModificationViewController.mode = .update
        patientModificationViewController.router?.dataStore?.patient = patient
        viewController?.navigationController?.pushViewController(patientModificationViewController, animated: true)
    }
    
    init(patientModificationViewControllerProvider: Provider<PatientModificationViewController>) {
        self.patientModificationViewControllerProvider = patientModificationViewControllerProvider
    }
}
