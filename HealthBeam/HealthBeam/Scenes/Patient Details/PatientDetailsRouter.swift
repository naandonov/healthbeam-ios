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
    func performNavigationCleanupIfNeeded()
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
        patientModificationViewController.router?.dataStore?.modificationDelegate = dataStore?.modificationDelegate
        patientModificationViewController.attributesUpdateHandler = viewController
        patientModificationViewController.mode = .update
        patientModificationViewController.router?.dataStore?.patient = patient
        viewController?.navigationController?.pushViewController(patientModificationViewController, animated: true)
    }

    func performNavigationCleanupIfNeeded() {
        if let viewControllersCount = viewController?.navigationController?.viewControllers.count,
            viewControllersCount > 2,
        let _ = viewController?.navigationController?.viewControllers[viewControllersCount - 2] as? PatientModificationViewController {
            viewController?.navigationController?.viewControllers.remove(at: viewControllersCount - 1)
        }
    }

    init(patientModificationViewControllerProvider: Provider<PatientModificationViewController>) {
        self.patientModificationViewControllerProvider = patientModificationViewControllerProvider
    }
}
