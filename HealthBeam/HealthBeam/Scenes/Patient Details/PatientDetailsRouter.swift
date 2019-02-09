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
    func routeToHealthRecord(_ healthRecord: HealthRecord)
    func routeToCreateHealthRecord(creator: UserProfile.ExternalModel)

}

protocol PatientDetailsDataPassing {
    var dataStore: PatientDetailsDataStore? {get set}
}

class PatientDetailsRouter:  PatientDetailsRoutingLogic, PatientDetailsDataPassing {
    
  weak var viewController: PatientDetailsViewController?
  var dataStore: PatientDetailsDataStore?
    
    private let patientModificationViewControllerProvider: Provider<PatientModificationViewController>
    private let healthRecordViewControllerProvider: Provider<HealthRecordViewController>
    private let healthRecordModificationViewControllerProvider: Provider<HealthRecordModificationViewController>
    
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
            viewController?.navigationController?.viewControllers.remove(at: viewControllersCount - 2)
        }
    }
    
    func routeToHealthRecord(_ healthRecord: HealthRecord) {
        let healthRecordViewController = healthRecordViewControllerProvider.get()
        healthRecordViewController.router?.dataStore?.healthRecord = healthRecord
        healthRecordViewController.router?.dataStore?.modificationDelegate = viewController
        viewController?.navigationController?.pushViewController(healthRecordViewController, animated: true)
    }
    
    func routeToCreateHealthRecord(creator: UserProfile.ExternalModel) {
        let healthRecordModificationViewController = healthRecordModificationViewControllerProvider.get()
        healthRecordModificationViewController.router?.dataStore?.patient = dataStore?.patient
        healthRecordModificationViewController.router?.dataStore?.healthRecord = HealthRecord.emptySnapshot(creator: creator)
        healthRecordModificationViewController.router?.dataStore?.modificationDelegate = viewController
        healthRecordModificationViewController.router?.dataStore?.healthRecordViewControllerProvider = healthRecordViewControllerProvider
        healthRecordModificationViewController.mode = .create
        viewController?.navigationController?.pushViewController(healthRecordModificationViewController, animated: true)
    }

    init(patientModificationViewControllerProvider: Provider<PatientModificationViewController>,
         healthRecordViewControllerProvider: Provider<HealthRecordViewController>, healthRecordModificationViewControllerProvider: Provider<HealthRecordModificationViewController>) {
        self.patientModificationViewControllerProvider = patientModificationViewControllerProvider
        self.healthRecordViewControllerProvider = healthRecordViewControllerProvider
        self.healthRecordModificationViewControllerProvider = healthRecordModificationViewControllerProvider
    }
}
