//
//  PatientsSearchRouter.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 21.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

protocol PatientsSearchRoutingLogic {
    var viewController: PatientsSearchViewController? { get set }
    
    func routeToPatientDetails()
    func routeToCreatePatient()
}

protocol PatientsSearchDataPassing {
    var dataStore: PatientsSearchDataStore? {get set}
}

class PatientsSearchRouter:  PatientsSearchRoutingLogic, PatientsSearchDataPassing {
    
  weak var viewController: PatientsSearchViewController?
  var dataStore: PatientsSearchDataStore?
    
    private let patientDetailsViewControllerProvider: Provider<PatientDetailsViewController>
    private let patientModificationViewControllerProvider: Provider<PatientModificationViewController>
    
    func routeToPatientDetails() {
        let patientDetailsViewController = patientDetailsViewControllerProvider.get()
        patientDetailsViewController.router?.dataStore?.patient = dataStore?.selectedPatient
        patientDetailsViewController.router?.dataStore?.patientAttributes = dataStore?.selectedPatientAttributes
        patientDetailsViewController.modificationDelegate = viewController
        viewController?.navigationController?.pushViewController(patientDetailsViewController, animated: true)
    }
    
    func routeToCreatePatient() {
        let patientModificationViewController = patientModificationViewControllerProvider.get()
        patientModificationViewController.modificationDelegate = viewController
        patientModificationViewController.mode = .create
        patientModificationViewController.router?.dataStore?.patient = Patient.emptySnapshot()
        viewController?.navigationController?.pushViewController(patientModificationViewController, animated: true)
    }

    
    init(patientDetailsViewControllerProvider: Provider<PatientDetailsViewController>,
         patientModificationViewControllerProvider: Provider<PatientModificationViewController>) {
        self.patientDetailsViewControllerProvider = patientDetailsViewControllerProvider
        self.patientModificationViewControllerProvider = patientModificationViewControllerProvider
    }
    
}
